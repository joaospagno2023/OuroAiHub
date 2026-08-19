from fastapi import FastAPI


app = FastAPI(
    title="OuroAI Hub",
    description="Portal corporativo de templates de Inteligência Artificial da OuroWeb.",
    version="1.0.0",
)


@app.get("/health")
def health() -> dict[str, str]:
    return {
        "status": "ok",
        "application": "OuroAI Hub",
        "version": "1.0.0",
    }