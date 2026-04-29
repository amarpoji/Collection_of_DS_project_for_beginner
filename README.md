<p align="center">
  <img src="https://img.shields.io/badge/Python-3.10%2B-3776AB?style=for-the-badge&logo=python&logoColor=white" alt="Python"/>
  <img src="https://img.shields.io/badge/scikit--learn-1.3%2B-F7931E?style=for-the-badge&logo=scikit-learn&logoColor=white" alt="scikit-learn"/>
  <img src="https://img.shields.io/badge/Status-Active-10B981?style=for-the-badge" alt="Active"/>
  <img src="https://img.shields.io/badge/Beginners-Welcome-8B5CF6?style=for-the-badge" alt="Beginners Welcome"/>
</p>

<p align="center">
  <img src="https://capsule-render.vercel.app/api?type=waving&height=200&color=gradient&customColorList=12,14,18,20,24&text=Collection%20of%20DS%20Projects&fontSize=36&fontAlignY=35&desc=for%20beginners%20%E2%80%A2%20by%20beginners%20%E2%80%A2%20with%20%E2%9D%A4%EF%B8%8F&descAlignY=55&descSize=18"/>
</p>

<h3 align="center">
  📊 A growing collection of beginner-friendly Data Science & Machine Learning projects
</h3>

<p align="center">
  <i>Each project is a complete, standalone notebook — from problem definition to final insights.</i>
</p>

<br/>

---

## 🎯 Why This Repo?

I'm **amarpoji** — learning data science one project at a time. This repo is my notebook dump, study log, and reference all rolled into one. Every project here follows the same structure:

```
📁 problem_name/
 ├── 📓 notebook/       → Jupyter notebook (full pipeline)
 ├── 📊 visualization/  → diagrams, charts, workflow maps
 ├── 📦 data/           → datasets (gitignored, download separately)
 └── 🐍 venv/           → virtual environment (gitignored)
```

> **For beginners:** Each notebook is self-contained, heavily commented, and walks through every step — no skipped cells, no magic.

---

## 📚 Projects

<!--
  ██████  ADD YOUR PROJECT HERE  ██████
  Copy the block below for each new project.
  Keep the table sorted by number (newest last, or group by category).
-->

| # | Project | Domain | Key Skills | Tags | F1 |
|:-:|:--------|:------:|:-----------|:----:|:--:|
| 1 | [**NLP with Disaster Tweets**](./NLP_with_disaster_tweet/) | NLP · Classification | TF-IDF, Logistic Regression, NLTK, GridSearchCV | `text` `kaggle` | **0.744** |

<details>
<summary><strong>📌 Planned / In Progress</strong></summary>
<br/>

| # | Project Idea | Domain | Skills Covered |
|:-:|:-------------|:------:|:---------------|
| — | Titanic Survival Prediction | Classification | pandas, feature engineering, ensemble |
| — | House Price Regression | Regression | EDA, correlation, Ridge/Lasso |
| — | Customer Segmentation | Clustering | K-Means, PCA, silhouette analysis |
| — | Spotify Song Recommender | Recommender | cosine similarity, content-based filtering |
| — | Credit Card Fraud Detection | Anomaly | imbalance handling, SMOTE, ROC-AUC |
| — | Sentiment Analysis on Movie Reviews | NLP | word embeddings, transformers, BERT |

> *Open an issue or PR if you'd like to collaborate on any of these!*

</details>

---

## 🔬 Project Spotlight

### 1. 🧠 NLP with Disaster Tweets

**Kaggle Challenge — Real or Not? NLP with Disaster Tweets**

Given a tweet, predict whether it's about a **real disaster** or not. A classic NLP classification problem with real-world impact — automatic disaster detection from social media feeds.

```
🎯 Task       → Binary Classification
📊 Data       → 7,613 train / 3,263 test samples
⚙️ Technique  → TF-IDF + Logistic Regression
📈 Best F1    → 0.744 ± 0.010 (5-fold CV)
🏆 Top Signal → "hiroshima", "wildfire", "earthquake" → Disaster
```

<details>
<summary><strong>📖 Pipeline Overview</strong></summary>

| Stage | Phase | What Happens |
|:-----:|:-----:|:-------------|
| 01 | Foundation | Problem definition, metric selection (F1) |
| 02 | Ingestion | Load data, inspect types & missing values |
| 03 | Analysis | EDA — text length, word clouds, hashtag patterns |
| 04 | Cleaning | Regex cleanup, stopword removal, lemmatization (NLTK) |
| 05 | Encoding | TF-IDF with unigrams + bigrams (5,000 features) |
| 06 | Training | 4 classifiers compared (LR, NB, RF, SVM) |
| 07 | Optimization | 5-fold CV + GridSearchCV + coefficient analysis |
| 08 | Production | Test predictions → `submission.csv` |
| 09 | Insights | Findings, limitations, future work |

</details>

<p align="center">
  <a href="./NLP_with_disaster_tweet/visualization/workflow.html">
    <img src="https://img.shields.io/badge/📊_View_Workflow_Diagram-0A0A12?style=for-the-badge" alt="Workflow Diagram">
  </a>
  <a href="./NLP_with_disaster_tweet/notebook/disaster_tweets_nlp_pipeline.ipynb">
    <img src="https://img.shields.io/badge/📓_Open_Notebook-FF6F00?style=for-the-badge&logo=jupyter&logoColor=white" alt="Notebook">
  </a>
</p>

---

## 🛠️ Getting Started

### Prerequisites

```bash
# Python 3.10+ recommended
python --version

# Each project has its own venv (optional)
python -m venv venv
source venv/bin/activate    # Linux / macOS
# .\venv\Scripts\activate   # Windows
```

### Run a Project

```bash
# Navigate to any project folder
cd NLP_with_disaster_tweet

# Install dependencies (from within the project)
pip install pandas numpy matplotlib seaborn scikit-learn nltk wordcloud jupyter

# Launch the notebook
jupyter notebook notebook/disaster_tweets_nlp_pipeline.ipynb
```

> 💡 **Tip:** Each project's `visualization/` folder contains diagram files you can open directly in your browser.

---

## 📁 Repository Structure

```
/
├── 📁 NLP_with_disaster_tweet/          # Project 1: NLP Classification
│   ├── 📁 notebook/                     #   ─ Jupyter notebooks
│   ├── 📁 visualization/                #   ─ Workflow diagrams
│   ├── 📁 data/                         #   ─ Datasets (gitignored)
│   └── .gitignore                       #   ─ Project-level ignores
│
├── 📁 your_next_project_here/           # ← Add yours here!
│   ├── 📁 notebook/
│   ├── 📁 visualization/
│   ├── 📁 data/
│   └── .gitignore
│
├── .gitignore                           # Root-level ignores
└── README.md                            # ← You are here
```

---

## 🤝 Contributing

This is primarily my learning repo, but hey — two brains are better than one!

**Ways to help:**
- 🐛 Found a bug? Open an [issue](https://github.com/amarpoji/Collection_of_DS_project_for_beginner/issues)
- 💡 Have a suggestion? I'm all ears
- 📝 Want to add a project? Fork → Add → PR (please follow the structure above)
- ⭐ Star the repo — it motivates me to keep building!

**Project submission checklist:**
- [ ] Self-contained notebook (all cells run top-to-bottom)
- [ ] Problem definition & conclusion cells
- [ ] Visualization folder with at least one workflow diagram
- [ ] `.gitignore` that excludes `data/` and `venv/`
- [ ] Dataset download instructions or link (no large files in git)

---

## 📜 License

<p align="center">
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/License-MIT-10B981?style=for-the-badge" alt="MIT License">
  </a>
</p>

<p align="center">
  Free to use, share, and learn from.
</p>

---

<p align="center">
  <sub>Made with ⚡ by <a href="https://github.com/amarpoji">amarpoji</a> &middot;
  Built one notebook at a time &middot; 🚀</sub>
</p>

<p align="center">
  <img src="https://capsule-render.vercel.app/api?type=waving&height=120&color=gradient&customColorList=12,14,18,20,24&section=footer"/>
</p>
