# 📚 Book Recommendation Engine

A **serverless web application** that recommends books based on user-provided genres. It uses the **Google Books API** to fetch recommendations and is fully provisioned with AWS and Terraform.

---

## 🚀 Live Demo

> **Frontend:** Deployed via AWS S3 + CloudFront  
> **API Endpoint:** AWS API Gateway + Lambda (Python)

---

## 🧰 Tech Stack

| Layer          | Tool / Service                     |
| -------------- | ---------------------------------- |
| Infrastructure | Terraform (Infrastructure as Code) |
| Backend        | AWS Lambda (Python)                |
| API Gateway    | HTTP API                           |
| Database       | DynamoDB (for caching)             |
| Frontend       | HTML + Tailwind CSS (hosted on S3) |
| CI/CD          | GitHub Actions                     |
| External API   | Google Books API                   |

---

## ✨ Features

- 🔍 Book recommendations by genre (e.g. *Romance*, *History*)
- ⚡ Fast responses with DynamoDB-based caching
- ☁️ 100% serverless (scalable and cost-efficient)
- 🌐 CORS-enabled for public access
- 🔄 Automatic deployment via GitHub Actions

---

## 🏗️ Infrastructure Overview

All infrastructure is defined in **Terraform**, with the following modules:

- `lambda`: Python handler that fetches books and caches them
- `dynamodb`: NoSQL database for genre-based caching
- `api_gateway`: HTTP API routing
- `s3_frontend`: Static site hosting
- `cloudwatch`: Centralized logging

---

## 🔁 GitHub Actions CI/CD

This project uses **GitHub Actions** to automate:

- ✅ Terraform linting and validation
- 🚀 Deployment to AWS when pushing to `main` branch

> CI/CD workflow is located at `.github/workflows/deploy.yml`

---

## 💡 Example Usage

1. Visit the frontend in your browser  
2. Type a genre like **history** or **romance**  
3. Click **"Get Recommendations"**  
4. See book results with titles, authors, and summaries

---

## 🧪 Local Development & Deployment

```bash
# 1. Comment out the S3 backend block in infra/main.tf if testing locally
# 2. Set up your AWS credentials locally or export them as environment variables

# 3. Initialize and deploy Terraform
cd infra
terraform init
terraform apply

# 4. (Optional) Package Lambda manually
cd modules/lambda
zip -r ../../lambda.zip handler.py requests/

# 5. Commit and push changes to trigger GitHub Actions deployment
git add .
git commit -m "Trigger deployment"
git push
