package com.flappybird;

import android.graphics.Canvas;
import android.graphics.Paint;

public class Bird {
    private float x, y;
    private float velocity;
    private float gravity = 0.6f;
    private float jumpStrength = -12f;
    private int radius = 30;

    private Paint paint;

    public Bird(float startX, float startY) {
        this.x = startX;
        this.y = startY;
        this.velocity = 0;

        paint = new Paint();
        paint.setColor(0xFFFFD700); // Gold color
        paint.setAntiAlias(true);
    }

    public void update() {
        velocity += gravity;
        y += velocity;
    }

    public void jump() {
        velocity = jumpStrength;
    }

    public void draw(Canvas canvas) {
        canvas.drawCircle(x, y, radius, paint);
    }

    public void reset(float startX, float startY) {
        this.x = startX;
        this.y = startY;
        this.velocity = 0;
    }

    public float getX() {
        return x;
    }

    public float getY() {
        return y;
    }

    public int getRadius() {
        return radius;
    }

    public boolean isOutOfBounds(int screenHeight) {
        return y - radius < 0 || y + radius > screenHeight;
    }
}
