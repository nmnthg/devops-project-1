# 🚀 Next.js CI/CD Pipeline with Docker, AWS, and Terraform  

This project demonstrates a complete **CI/CD pipeline** for a **Next.js React application**, containerized with **Docker** and deployed to **AWS** using **Terraform** for infrastructure provisioning.  

The application includes both a **homepage UI** and an **API layer**. On every code commit:  
- The app is built into a **Docker image** and pushed to **Amazon ECR**.  
- **Terraform** provisions the AWS infrastructure, including:  
  - Public and private subnets  
  - Application Load Balancer (ALB)  
  - AWS Fargate for serverless container orchestration  

This setup ensures **scalability, reliability, and high availability** while streamlining deployment workflows.  

---

## 🚢 Deployment Workflow
1. **Commit code** → triggers CI/CD pipeline  
2. **Docker build** → image pushed to **Amazon ECR**  
3. **Terraform apply** → provisions AWS infrastructure (VPC, subnets, ALB, Fargate)  
4. **Application deployed** → available behind **ALB endpoint**  

---

## 🌐 Infrastructure Overview
- **VPC** with public & private subnets  
- **Application Load Balancer** for incoming traffic  
- **ECS Fargate tasks** running the containerized app  
- **Amazon ECR** for storing Docker images  
- **Terraform** for managing all resources as code  
