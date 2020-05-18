---
title: Using Kotlin coroutines to handle blocking computations in Android
author: rainbyte
published: 2020-05-18 05:23:00
tags: android, async, coroutines, kotlin 
language: es
commentsIssue: 5
---

When we need to execute time intensive computations and show some the result
to the user, we should avoid running them inside UI thread, otherwise app UI
could get frozen.

Here we have a detailed example which uses a coroutine to run Fibonacci fib
function without blocking app UI:

```kotlin
class MainActivity : AppCompatActivity(), CoroutineScope {

    // Blocking computation, requires too much time to finish
    fun fib(x: Int): Int = if (x <= 1) x else fib(x - 1) + fib(x - 2)

    // Attach coroutines context to activity
    override val coroutineContext: CoroutineContext =
            Dispatchers.Main + SupervisorJob()

    // Coroutines should respect activity lifetime
    override fun onDestroy() {
        super.onDestroy()
        coroutineContext[Job]!!.cancel()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        btnCalc.setOnClickListener {
            val number: Int = editNumber.text.toString().toInt()
            // Start coroutine on the context attached to activity
            this.launch {
                // Switch to IO dispatcher to perform blocking computation
                val result = withContext(Dispatchers.IO) {
                    fib(number)
                }
                if (result != null) {
                    editResult.setText(result.toString())
                }
            }
        }
    }
}
```

UI code is also provided to complete the example

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    android:layout_margin="10dp"
    tools:context=".MainActivity">

    <TextView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Number" />

    <EditText
        android:id="@+id/editNumber"
        android:layout_width="match_parent"
        android:layout_height="wrap_content" />

    <TextView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Result" />

    <EditText
        android:id="@+id/editResult"
        android:layout_width="match_parent"
        android:layout_height="wrap_content" />

    <Button
        android:id="@+id/btnCalc"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Calculate fib(number)" />

</LinearLayout>
```
