package com.flappybird;

import android.graphics.Canvas;
import android.graphics.Paint;

public class Pipe {
    private float x;
    private float topHeight;
    private float bottomY;
    private int width = 100;
    private int gap = 400;
    private float speed = 5;
    private boolean passed = false;

    private Paint paint;

    public Pipe(float x, int screenHeight) {
        this.x = x;
        // Random height for top pipe (between 100 and screenHeight - gap - 100)
        this.topHeight = (float) (Math.random() * (screenHeight - gap - 200) + 100);
        this.bottomY = topHeight + gap;

        paint = new Paint();
        paint.setColor(0xFF228B22); // Forest Green
        paint.setAntiAlias(true);
    }

    public void update() {
        x -= speed;
    }

    public void draw(Canvas canvas, int screenHeight) {
        // Draw top pipe
        canvas.drawRect(x, 0, x + width, topHeight, paint);

        // Draw bottom pipe
        canvas.drawRect(x, bottomY, x + width, screenHeight, paint);
    }

    public boolean isOffScreen() {
        return x + width < 0;
    }

    public boolean collidesWith(Bird bird) {
        float birdX = bird.getX();
        float birdY = bird.getY();
        int birdRadius = bird.getRadius();

        // Check if bird is in horizontal range of pipe
        if (birdX + birdRadius > x && birdX - birdRadius < x + width) {
            // Check if bird hits top or bottom pipe
            if (birdY - birdRadius < topHeight || birdY + birdRadius > bottomY) {
                return true;
            }
        }
        return false;
    }

    public boolean isPassed(Bird bird) {
        return !passed && bird.getX() > x + width;
    }

    public void setPassed(boolean passed) {
        this.passed = passed;
    }

    public float getX() {
        return x;
    }
}
