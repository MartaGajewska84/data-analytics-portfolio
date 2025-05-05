# 🎬 TikTok Content Engagement Analysis Project

## 🔍 Project Overview

This project explores content engagement patterns on the TikTok platform through detailed Exploratory Data Analysis (EDA) and dashboard visualizations. The goal is to understand how different factors — such as claim status, author verification, and account ban status — relate to video performance metrics like views, likes, comments, shares, and video duration.

The analysis was conducted in two main parts:

- **Python (Jupyter Notebook)**: Performed data cleaning, transformation, and EDA.
- **Tableau Dashboard**: Designed interactive visualizations to summarize key insights from the dataset.

The ultimate objective of this project was also to prepare the dataset for future machine learning modeling that predicts whether a video contains a "claim" or an "opinion."

---

## 🛠️ Tools and Technologies

- Python (Pandas, Seaborn, Matplotlib)
- Tableau Public (Dashboard Development)
- Jupyter Notebook

---

## 📊 Key Analyses Performed

- Distribution of account types: verified vs. unverified users
- Analysis of author ban statuses (active, banned, under review)
- Distribution of engagement metrics: views, likes, comments, shares
- Exploration of how video duration relates to average view count
- Examination of engagement rates based on claim vs. opinion status
- Comparative analysis of user behavior across different author statuses

---

## 📈 Datasets Used

The dataset included the following fields:

- **claim_status**: Indicates whether a video is labeled as a "claim" or "opinion"
- **verified_status**: Whether the author’s account is verified
- **author_ban_status**: Status of the author's account (active, banned, under review)
- **video_view_count**: Total number of views per video
- **video_like_count**: Total number of likes per video
- **video_comment_count**: Total number of comments per video
- **video_share_count**: Total number of shares per video
- **video_duration_sec**: Length of the video in seconds

Derived metrics (like "likes per view") were created during the analysis phase.

---

## 📊  Deliverables

- **tiktok_eda.ipynb**: Contains all Python code for data cleaning, analysis, and visualizations
- **TikTokProject.twb**: Tableau workbook with interactive dashboards summarizing key findings

---

## 🔍 Key Insights

- Verified accounts are much fewer but tend to post more opinion content.
- Banned and under-review authors are more likely to post claim videos.
- The distribution of views, likes, comments, and shares is highly right-skewed.
- Longer videos do not necessarily guarantee higher engagement — the relationship varies depending on claim status and account type.

---


