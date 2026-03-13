#!/bin/bash
# DDR Report Generator — Startup Script

set -e

echo ""
echo "╔══════════════════════════════════════╗"
echo "║     DDR Report Generator v1.0.0      ║"
echo "╚══════════════════════════════════════╝"
echo ""

# Check .env
if [ ! -f ".env" ]; then
  if [ -f ".env.example" ]; then
    cp .env.example .env
    echo "⚠  Created .env from .env.example — please add your ANTHROPIC_API_KEY"
    echo ""
  fi
fi

# Load env
if [ -f ".env" ]; then
  export $(grep -v '^#' .env | xargs)
fi

# Check API key
if [ -z "$ANTHROPIC_API_KEY" ] || [ "$ANTHROPIC_API_KEY" = "your_api_key_here" ]; then
  echo "❌ ERROR: ANTHROPIC_API_KEY not set in .env"
  echo "   Add your key: ANTHROPIC_API_KEY=sk-ant-..."
  exit 1
fi

# Install Python deps
echo "📦 Installing Python dependencies..."
pip install -r backend/requirements.txt -q --break-system-packages

echo ""
echo "✅ Starting server at http://localhost:8000"
echo "   API docs at   http://localhost:8000/docs"
echo ""

# Run
cd backend
uvicorn main:app --host 0.0.0.0 --port 8000 --reload