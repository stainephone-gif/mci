package com.flappybird;

import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.view.MotionEvent;
import android.view.SurfaceHolder;
import android.view.SurfaceView;

import java.util.ArrayList;
import java.util.List;

public class GameView extends SurfaceView implements Runnable {

    private Thread gameThread;
    private SurfaceHolder surfaceHolder;
    private boolean isPlaying;
    private boolean isGameOver;
    private boolean isGameStarted;

    private Bird bird;
    private List<Pipe> pipes;
    private int score;
    private int bestScore;

    private Paint scorePaint;
    private Paint textPaint;
    private Paint backgroundPaint;

    private int screenWidth;
    private int screenHeight;
    private int frameCount;

    private SharedPreferences prefs;

    public GameView(Context context) {
        super(context);
        surfaceHolder = getHolder();

        prefs = context.getSharedPreferences("FlappyBird", Context.MODE_PRIVATE);
        bestScore = prefs.getInt("bestScore", 0);

        // Initialize paints
        scorePaint = new Paint();
        scorePaint.setColor(Color.WHITE);
        scorePaint.setTextSize(80);
        scorePaint.setTextAlign(Paint.Align.CENTER);
        scorePaint.setAntiAlias(true);

        textPaint = new Paint();
        textPaint.setColor(Color.WHITE);
        textPaint.setTextSize(60);
        textPaint.setTextAlign(Paint.Align.CENTER);
        textPaint.setAntiAlias(true);

        backgroundPaint = new Paint();
        backgroundPaint.setColor(0xFF87CEEB); // Sky Blue
    }

    private void init() {
        bird = new Bird(screenWidth / 4, screenHeight / 2);
        pipes = new ArrayList<>();
        score = 0;
        frameCount = 0;
        isGameOver = false;
        isGameStarted = false;
    }

    @Override
    public void run() {
        while (isPlaying) {
            update();
            draw();
            sleep();
        }
    }

    private void update() {
        if (!isGameStarted || isGameOver) {
            return;
        }

        bird.update();

        // Check if bird is out of bounds
        if (bird.isOutOfBounds(screenHeight)) {
            gameOver();
            return;
        }

        // Update pipes
        for (int i = pipes.size() - 1; i >= 0; i--) {
            Pipe pipe = pipes.get(i);
            pipe.update();

            // Check collision
            if (pipe.collidesWith(bird)) {
                gameOver();
                return;
            }

            // Check if pipe is passed
            if (pipe.isPassed(bird)) {
                pipe.setPassed(true);
                score++;
            }

            // Remove off-screen pipes
            if (pipe.isOffScreen()) {
                pipes.remove(i);
            }
        }

        // Add new pipes
        frameCount++;
        if (frameCount % 90 == 0) { // Add pipe every 90 frames
            pipes.add(new Pipe(screenWidth, screenHeight));
        }
    }

    private void draw() {
        if (surfaceHolder.getSurface().isValid()) {
            Canvas canvas = surfaceHolder.lockCanvas();

            // Draw background
            canvas.drawRect(0, 0, screenWidth, screenHeight, backgroundPaint);

            if (isGameStarted) {
                // Draw pipes
                for (Pipe pipe : pipes) {
                    pipe.draw(canvas, screenHeight);
                }

                // Draw bird
                bird.draw(canvas);

                // Draw score
                canvas.drawText("Score: " + score, screenWidth / 2, 100, scorePaint);

                if (isGameOver) {
                    // Draw game over text
                    canvas.drawText("GAME OVER", screenWidth / 2, screenHeight / 2 - 100, textPaint);
                    canvas.drawText("Score: " + score, screenWidth / 2, screenHeight / 2, textPaint);
                    canvas.drawText("Best: " + bestScore, screenWidth / 2, screenHeight / 2 + 80, textPaint);
                    canvas.drawText("Tap to restart", screenWidth / 2, screenHeight / 2 + 200, textPaint);
                }
            } else {
                // Draw start screen
                canvas.drawText("FLAPPY BIRD", screenWidth / 2, screenHeight / 2 - 100, textPaint);
                canvas.drawText("Tap to start", screenWidth / 2, screenHeight / 2 + 100, textPaint);
            }

            surfaceHolder.unlockCanvasAndPost(canvas);
        }
    }

    private void sleep() {
        try {
            Thread.sleep(17); // ~60 FPS
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    private void gameOver() {
        isGameOver = true;
        if (score > bestScore) {
            bestScore = score;
            prefs.edit().putInt("bestScore", bestScore).apply();
        }
    }

    public void resume() {
        isPlaying = true;
        gameThread = new Thread(this);
        gameThread.start();
    }

    public void pause() {
        try {
            isPlaying = false;
            gameThread.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        if (event.getAction() == MotionEvent.ACTION_DOWN) {
            if (!isGameStarted) {
                isGameStarted = true;
            } else if (isGameOver) {
                init();
            } else {
                bird.jump();
            }
        }
        return true;
    }

    @Override
    protected void onSizeChanged(int w, int h, int oldw, int oldh) {
        super.onSizeChanged(w, h, oldw, oldh);
        screenWidth = w;
        screenHeight = h;
        init();
    }
}
