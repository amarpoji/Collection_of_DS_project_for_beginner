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

<details>
<summary><strong>📌 Planned / In Progress (Jupyter Notebooks)</strong></summary>
<br/>

*Each project will be built as a self-contained Jupyter notebook with: data generation, EDA, modeling, visualisations, and business recommendations.*

| # | Project Idea | Domain | Skills Covered |
|:-:|:-------------|:------:|:---------------|
| 1 | **Titanic Survival Prediction** | Classification | pandas, feature engineering, ensemble, missing value imputation |
| 2 | **House Price Regression** | Regression | EDA, correlation, Ridge/Lasso, feature selection |
| 3 | **Credit Card Fraud Detection** | Anomaly | imbalance handling, SMOTE, ROC-AUC, undersampling |
| 4 | **Chatbot with BERT** | NLP · Transformers | fine-tuning, Hugging Face, tokenisation, attention |
| 5 | **A/B Testing Analyzer** | Statistics | hypothesis testing, confidence intervals, power analysis |
| 6 | **Model Interpretability (SHAP/LIME)** | XAI · MLOps | SHAP values, LIME, feature importance, model debugging |
| 7 | **Deploy ML Model as API** | MLOps | FastAPI, Docker, CI/CD, model serialisation |
| 8 | **Web Scraper + Topic Modeling** | NLP · Scraping | BeautifulSoup, LDA, NMF, text preprocessing |
| 9 | **Fake News Detection** | NLP · Classification | word embeddings, LSTMs, attention, explainability |
|10 | **LLM Fine-tuning with LoRA** | Generative AI · LLMs | LoRA, PEFT, QLoRA, instruction tuning |
|11 | **End-to-End MLOps Pipeline** | MLOps · DevOps | DVC, MLflow, feature store, model registry, monitoring |
|12 | **Olympic Games 120 Years** | EDA · Sports | historical trends, medal counts, country analysis, storytelling |
|13 | **Video Game Sales Analysis** | EDA · Gaming | genre trends, platform lifecycle, regional analysis, regression |
|14 | **Breast Cancer Detection** | Medical · Classification | feature selection, SVM, confusion matrices, ROC curves |
|15 | **WhatsApp Chat Analyzer** | NLP · Personal | emoji stats, sentiment over time, word clouds, message patterns |
|16 | **Wine Quality Prediction** | Regression · Chemistry | chemical features, feature importance, model comparison |
|17 | **Bike Sharing Demand** | Time Series · Regression | seasonality, weather impact, holiday effects, lag features |
|18 | **Airbnb Price Prediction** | Regression · Geo | location encoding, amenities, price optimisation, outliers |
|19 | **Netflix Content Analysis** | EDA · Media | content trends over years, country distribution, rating analysis |
|20 | **Health Insurance Cost** | Regression · Healthcare | BMI analysis, smoker impact, region-wise costs, interaction terms |
|21 | **Student Grades Predictor** | Classification · Education | demographic factors, study habits, feature engineering |
|22 | **Market Basket Analysis** | Association Rules · Retail | Apriori algorithm, frequent itemsets, product placement insights |
|23 | **Sleep Health & Lifestyle** | EDA · Health | sleep vs exercise, occupation effects, lifestyle correlations |
|24 | **Global Terrorism Database** | EDA · Geopolitics | attack trends, target analysis, casualty patterns, mapping |
|25 | **Pokemon Battle Predictor** | Classification · Fun | type advantages, stats analysis, team building, visualisations |
|26 | **Star Type Classification** | Astronomy · Physics | spectral analysis, HR diagram, magnitude vs temperature |

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
