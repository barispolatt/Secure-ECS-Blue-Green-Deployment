from fastapi import FastAPI, Response
import os

app = FastAPI()

# this variables will be injected from ECS to change color from config without touching the code
APP_VERSION = os.getenv("APP_VERSION", "v1")
BG_COLOR = os.getenv("BG_COLOR", "blue") 

@app.get("/")
def read_root():
    html_content = f"""
    <html>
        <head>
            <style>
                body {{ background-color: {BG_COLOR}; color: white; display: flex; 
                        justify-content: center; align-items: center; height: 100vh; 
                        font-family: sans-serif; font-size: 3rem; flex-direction: column; }}
            </style>
            <meta http-equiv="refresh" content="1"> 
        </head>
        <body>
            <div>Blue/Green Deployment Demo</div>
            <div style="font-size: 1.5rem; margin-top: 20px;">Version: {APP_VERSION}</div>
        </body>
    </html>
    """
    return Response(content=html_content, media_type="text/html")

@app.get("/health")
def health():
    # Load Balancer and CodeDeploy looks to this endpoint'e to see if application is live.
    return {"status": "healthy"}