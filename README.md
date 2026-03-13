# DDR Report Generator

> AI-powered system that converts raw site inspection and thermal documents into structured, client-ready Detailed Diagnostic Reports.

---
## UI Design :
<img width="1920" height="1080" alt="Screenshot (127)" src="https://github.com/user-attachments/assets/0b743916-ae46-4bf8-bdf1-bb08b1b78976" />


## Overview

This project was built as part of an Applied AI Builder assignment. The system accepts two input documents — an **Inspection Report** and a **Thermal Report** — and uses an LLM to extract, merge, and structure the data into a professional DDR with 7 standardised sections, exportable as PDF or Word.

**Live Demo:** [your-railway-url.up.railway.app](https://your-railway-url.up.railway.app)

---

## Features

- Upload inspection + thermal documents (PDF, TXT, or image)
- AI extracts and merges data from both documents intelligently
- Detects and flags conflicting information between documents
- Marks missing data explicitly as "Not Available" — no hallucination
- Generates a structured 7-section DDR report
- Extracts and embeds images from PDF pages into the report
- One-click export to PDF and Word (.docx)
- Works on any inspection/thermal documents, not just sample files
- REST API with auto-generated Swagger docs

---

## Tech Stack

| Layer | Technology |
|---|---|
| Backend | FastAPI (Python) |
| AI Model | Llama 3.3 70B via Groq API |
| PDF Parsing | pdfplumber, pypdf |
| PDF Generation | ReportLab |
| DOCX Generation | python-docx |
| Frontend | Plain HTML + CSS + JS (no framework) |
| Deployment | Railway |

---

## Project Structure

```
ddr-system/
├── backend/
│   ├── main.py          # FastAPI app — routes, AI logic, PDF/DOCX export
│   └── requirements.txt
├── frontend/
│   └── index.html       # Single-file UI
├── exports/             # Generated reports saved here
├── nixpacks.toml        # Railway build config
├── railway.json         # Railway deploy config
├── requirements.txt     # Root-level deps for Railway
└── .env.example
```

---

## DDR Output Structure

| # | Section | Description |
|---|---------|-------------|
| 01 | Property Issue Summary | Executive overview of all key findings |
| 02 | Area-wise Observations | Per-area findings with thermal data and images |
| 03 | Probable Root Cause | Likely cause behind each identified issue |
| 04 | Severity Assessment | High / Medium / Low rating with reasoning |
| 05 | Recommended Actions | Specific, prioritised action steps |
| 06 | Additional Notes | Warnings, context, or disclaimers |
| 07 | Missing / Unclear Info | Explicit flags for gaps and conflicts |

---

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/api/generate` | Upload both docs, returns DDR JSON + images |
| `POST` | `/api/export/pdf` | Generate PDF from report data |
| `POST` | `/api/export/docx` | Generate DOCX from report data |
| `GET`  | `/health` | Health check |
| `GET`  | `/docs` | Swagger UI |

---

## Running Locally

**1. Clone the repo**
```bash
git clone https://github.com/shreebarse12/AI-based-ddr-system_.git
cd AI-based-ddr-system_
```

**2. Install dependencies**
```bash
pip install -r requirements.txt
```

**3. Set your Groq API key**

Get a free key at [console.groq.com](https://console.groq.com)

```powershell
# Windows PowerShell
$env:GROQ_API_KEY="gsk_your_key_here"
```

```bash
# Mac / Linux
export GROQ_API_KEY=gsk_your_key_here
```

**4. Start the server**
```bash
uvicorn backend.main:app --host 0.0.0.0 --port 8000 --reload
```

**5. Open in browser**
```
http://localhost:8000
```

---

## Deployment (Railway)

1. Push code to GitHub
2. Go to [railway.app](https://railway.app) → New Project → Deploy from GitHub
3. Add environment variable: `GROQ_API_KEY = gsk_...`
4. Railway auto-builds and deploys via `nixpacks.toml`
5. Generate a public domain under Settings → Networking

---

## Design Decisions

**Why Groq + Llama 3.3 70B?**
Free tier, very fast inference, and strong structured JSON output — ideal for extracting and reasoning over technical documents.

**Why no hallucination?**
The system prompt strictly instructs the model never to invent facts. Any missing field defaults to `"Not Available"` and conflicting data between the two documents is explicitly flagged.

**Why plain HTML frontend?**
No build step, no framework overhead — just a single `index.html` that is served directly by FastAPI. Easy to maintain and deploy.

**Why pdfplumber over PyPDF alone?**
pdfplumber preserves text layout and extracts tables better, which matters for structured inspection reports.

---

## Limitations

- Scanned / image-only PDFs lose text (OCR not yet integrated)
- Large documents are truncated to fit context window limits
- No persistent storage — reports are not saved between sessions
- No authentication on the API

---

## Future Improvements

- OCR support for scanned PDFs using Tesseract
- Report history with SQLite database
- Multi-language support
- Confidence score per report section
- Email delivery of generated reports
