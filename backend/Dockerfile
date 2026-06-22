FROM python:3.10-slim-bookworm

WORKDIR /app

ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1
ENV RENDER=true

RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --upgrade pip && \
    pip install torch torchvision --index-url https://download.pytorch.org/whl/cpu && \
    pip install -r requirements.txt

COPY . .

RUN python -c "import torch; torch.hub.load('facebookresearch/pytorchvideo', 'slowfast_r50', pretrained=True); print('Modelo precargado OK')"

EXPOSE 5000

CMD gunicorn --bind 0.0.0.0:${PORT:-5000} --workers 1 --threads 2 --timeout 300 app:app
