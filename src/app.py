from fastapi import FastAPI, Response
import os
import uvicorn 

app = FastAPI()

# ECS Task Definition enviroment variables
# Default values for local tests
APP_VERSION = os.getenv("APP_VERSION", "v1")
BG_COLOR = os.getenv("BG_COLOR", "blue") 

@app.get("/")
def read_root():
    # this meta tag is for refresh every 1 seconds to follow blue-green transition
    html_content = f"""
    <html>
        <head>
            <title>Blue/Green Demo</title>
            <style>
                body {{ background-color: {BG_COLOR}; color: white; display: flex; 
                        justify-content: center; align-items: center; height: 100vh; 
                        font-family: sans-serif; font-size: 3rem; flex-direction: column; 
                        margin: 0; }}
                .info {{ font-size: 1.5rem; margin-top: 20px; opacity: 0.9; }}
            </style>
            <meta http-equiv="refresh" content="1"> 
        </head>
        <body>
            <div>Blue/Green Deployment Demo</div>
            <div class="info">Version: {APP_VERSION}</div>
            <div class="info" style="font-size: 1rem;">Host: {os.uname().nodename}</div>
        </body>
    </html>
    """
    return Response(content=html_content, media_type="text/html")

@app.get("/health")
def health():
    # check if ALB gives 200 OK to this endpoint, if it fails, ECS closes that container and opens new one
    return {"status": "healthy"}

# used uvicorn to test and develop in local
if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=80)