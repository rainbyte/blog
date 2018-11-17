---
title: Use GitHub API to implement comments feature
author: rainbyte
published: 2018-11-16 22:48:00
tags: blog
commentsIssue: 1
---

The comments section of this blog is implemented via standard GitHub issues and given that GitHub provides an API to access the public information of a repository, we can use it. If we have a repository with issues already created, we can access the comments of a certain issue using an URL like this one:

```default
https://api.github.com/repos/${username}/${repository}/issues/${issueId}/comments
```

Using that endpoint the API provides us the comments as a list of Javascript objects, each one being similar to this:

```javascript
{
    "body": "comment text",
    "created_at": "when was the comment published",
    "user: {
        "avatar_url": "user image location",
        "html_url": "user profile location",
        "login": "user nickname"
    }
}
```

Of course there are much more fields available, but these ones are representative enough and using them we can write some Javascript code to render the comments HTML view. This is the code used in this blog to render comments below:

```javascript
var issueId = $commentsIssue$;
var url = "https://github.com/rainbyte/rainbyte.github.io/issues/" + issueId;
var api_url = "https://api.github.com/repos/rainbyte/rainbyte.github.io/issues/" + issueId + "/comments";
(function() {
    // DOM is already available, now we can handle page elements
    var ghCommentsList = document.getElementById("gh-comments-list");

    var request = new XMLHttpRequest();
    request.open('GET', api_url, true);
    request.onload = function() {
        if (request.status >= 200 && request.status < 400) {
            // Request was successful, we can process the raw comments
            var comments = JSON.parse(request.responseText);
            var fragment = document.createDocumentFragment();
            var range = new Range();

            // Render comments section header
            fragment.appendChild(range.createContextualFragment(`
                <div>
                    <b>Comments section</b> (visit the <b><a href='${url}'>issue</a></b> of this post to add one)
                </div>
            `));

            // Render view of each comment
            comments.forEach(comment => {
                var date = new Date(comment.created_at);
                var renderedComment = range.createContextualFragment(`
                    <div class='gh-comment'>
                        <div class='gh-comment-header'>
                            <img src='$${comment.user.avatar_url}'>
                            <div>
                                <b><a href='${comment.user.html_url}'>${comment.user.login}</a></b> posted at <em>${date.toDateString()}</em>
                            </div>
                        </div>
                        <div class='gh-comment-body'>
                            $${comment.body}
                        </div>
                    </div>
                `);
                fragment.appendChild(renderedComment);
            });

            // Make changes visible by adding rendered nodes
            ghCommentsList.append(fragment);
        } else {
            // Request reached the target server, but it returned an error
            ghCommentsList.append("Comments are not available now.");
        }
    };
    request.onerror = function() {
        // There was a connection error of some sort
        ghCommentsList.append("Comments are not available now.");
    };
    request.send();
})();
```

If code is working ok, you can see a comments section under this text and add a new comment following the provided link.