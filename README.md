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

| # | Project | Domain | Key Skills | Tags | 
|:-:|:--------|:------:|:-----------|:----:|
| 1 | [**NLP with Disaster Tweets**](./NLP_with_disaster_tweet/) | NLP · Classification | TF-IDF, Logistic Regression, NLTK, GridSearchCV | `text` `kaggle` | 
| 2 | [**Spotify Song Recommender**](./spotify_song_recommender/) | Recommender Systems | cosine similarity, MinMaxScaler, audio features | `music` `huggingface` | 
| 3 | [**Sentiment Analysis on Twitter**](./sentiment_analysis/) | NLP · Classification | TF-IDF, Logistic Regression, Naive Bayes, NLTK, WordCloud | `text` `twitter` | 
| 4 | [**Customer Segmentation**](./customer_segmentation/) | Clustering · Unsupervised | K-Means, PCA, Silhouette Analysis, StandardScaler | `clustering` `retail` |
| 5 | [**Stock Price Forecasting**](./stock_price_forecasting/) | Time Series · Regression | yfinance, Feature Engineering, XGBoost, ARIMA, Walk-Forward CV | `finance` `real-data` |
| 6 | [**Movie Recommender System**](./movie_recommender_system/) | Recommender Systems · Collaborative Filtering | SVD, kNN, Content-Based, MovieLens, Matrix Factorization | `recommender` `real-data` |
| 7 | [**Time Series Anomaly Detection**](./time_series_anomaly_detection/) | Anomaly · Time Series | STL Decomposition, Isolation Forest, One-Class SVM, Autoencoder, NYC Taxi | `anomaly` `real-data` `deep-learning` |
| 8 | [**Image Classifier (CIFAR-10)**](./image_classifier/) | Computer Vision | CNN, Data Augmentation, Transfer Learning, PyTorch/TF | `vision` `cifar10` `deep-learning` |
| 9 | [**A/B Testing Analyzer**](./ab_testing_analyzer/) | Statistics | hypothesis testing, confidence intervals, z-test | `statistics` `ab-testing` `real-data` |
|10 | [**RAG Pipeline from Scratch**](./rag_pipeline/) | GenAI · RAG | chunking strategies, sentence embeddings, ChromaDB, cross-encoder reranking, T5 generation | `rag` `llm` `vector-db` `genai` |
|11 | [**SQL Mastery Course**](./sql_mastery_course/) | SQL · Database | 24 lessons, 65+ exercises, 5 projects + capstone, SQLite, JOINs, Window Functions, Query Optimization | `sql` `database` `learning` `curriculum` |

<details>
<summary><strong>📌 Planned / In Progress (Jupyter Notebooks)</strong></summary>
<br/>

*Each project will be built as a self-contained Jupyter notebook with: data generation, EDA, modeling, visualisations, and business recommendations.*

| # | Project Idea | Domain | Skills Covered |
|:-:|:-------------|:------:|:---------------|
| 1 | **RAG Pipeline from Scratch** | GenAI · RAG | chunking strategies, vector DBs (Chroma/Qdrant), embedding models, retrieval fusion, reranking, eval |
| 2 | **Multi-Agent LLM System** | GenAI · Agents | LangGraph/AutoGen, agent orchestration, tool use, memory, reflection, observability |
| 3 | **Graph Neural Networks for Molecules** | GNNs · Chemistry | PyTorch Geometric, message passing, SMILES parsing, molecular property prediction |
| 4 | **Self-Supervised Learning (SimCLR)** | CV · SSL | contrastive learning, data augmentations, NT-Xent loss, projection head, representation quality |
| 5 | **Diffusion Model for Image Gen** | CV · Generative | DDPM, U-Net, noise scheduling, classifier-free guidance, FID score |
| 6 | **RLHF from Scratch** | RL · Alignment | PPO, reward modeling, preference datasets, KL divergence, DPO comparison |
| 7 | **Multimodal Search with CLIP** | Multimodal · Retrieval | CLIP embeddings, cross-modal retrieval, FAISS, zero-shot classification |
| 8 | **Causal Inference & Uplift Modeling** | Causal · Stats | DoWhy, DAGs, ATE/CATE, uplift trees, A/B test debiasing |
| 9 | **Federated Learning for Healthcare** | FL · Privacy | Flower framework, differential privacy, heterogeneous data, secure aggregation |
|10 | **Knowledge Graph Construction** | KG · NLP | NER, relation extraction, Neo4j, SPARQL queries, graph embeddings |
|11 | **Bayesian Deep Learning** | Uncertainty · Prob | MC Dropout, Bayesian NN, VI, uncertainty quantification, active learning |
|12 | **Neural Architecture Search** | AutoML · NAS | evolutionary search, weight sharing, DARTS, hardware-aware NAS |
|13 | **Anomaly Detection on Graphs** | Graph · Security | PyG, graph autoencoders, GAD benchmark, fraud detection on transaction graphs |
|14 | **Code Generation with RAG** | GenAI · Code | code LLMs, semantic code retrieval, function calling, AST parsing |
|15 | **Time Series Foundation Model** | TS · Foundation | Lag-Llama/TimesFM, zero-shot forecasting, patch embeddings, distribution head |

> *Open an issue or PR if you'd like to collaborate on any of these!*

</details>

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
