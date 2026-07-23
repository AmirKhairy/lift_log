package com.example.lift_log

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import com.airbnb.lottie.LottieAnimationView

class SplashActivity : Activity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_splash)

        val lottieAnimation = findViewById<LottieAnimationView>(R.id.lottieAnimation)

        // Start the animation
        lottieAnimation.playAnimation()

        // Navigate after exactly 3 seconds
        lottieAnimation.postDelayed({
            startActivity(Intent(this@SplashActivity, MainActivity::class.java))
            overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out)
            finish()
        }, 3000)
    }
}