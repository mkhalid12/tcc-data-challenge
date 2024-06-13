
# TCC TECHNICAL CHALLENGE SOLUTION for Data Engineer Position

In this project, I have developed an end-to-end data-warehouse pipeline to integrate and analyse the customer orders, products and shops data for better data-driven decision by the higher management.

### Challenge
The challenge is to build proof of concept of DWH solution that able to scale, easy to manage and deploy over production and thougghly will be available for data team for collaboration

## Solution:
The solution is categorised in these 2 parts 1st is Production Ready solution for TCC end-to-end Data Platform Architecture and Second part is the POC deliverable solution for this proposed architecture which contains the minimum working example 

## 1. TCC Data & AI Platform Architecture 
Our vision is to make a TCC for data-driven decision for business growth and better product development. We adopted a Lakehouse Architecture on AWS that provide the single source of truth of data combined from multiple resources. This approach combines data lake flexibility with data warehouse features for advanced analytics, machine learning, and real-time insights.
The architecture is designed to:
1. Facilitate comprehensive analytics and machine learning across vast, varied data sets.
2. Streamline data ingestion, storage, and analysis, optimising for efficiency and scalability.
3. Ensure superior data quality, governance, and compliance standards.
4. Enable both real-time and batch processing to support dynamic data needs.
5. Cost-effective solution to build a centralised single source of data. 

#### Lakehouse Architecture 
Based on the architecture designe I proposed the ETL Pipeline Implementation using Medallion Architecture design pattern. This architecture logically organizes the data into progressive layers (Bronze->Silver->Gold) based on the quality of the data. In this architecture, we ensure Data Quality improvement in each layer. For data governance, we can restrict and provide restricted data access easily using this layered data quality approach.

![archiecture_concepts.png](images%2Farchiecture_concepts.png)

The description of each layer as follows
In this project the Layers Bronze, Silver, and Gold data present as `raw`,  `sta` and `stg` respectively.

**Bronze Layer (Raw Data)**: Landing layer with untouched as-it-is data. We could use AWS S3 bucket to persist the raw data.  The strategy of this layer is append-only where we can evolve the schema changes without any breaking changes and use the Data Catalog tools like AWS Glue Data Catalog to apply the scehma layer on top of s3 files.

**Silver Layer (Filtered and Clean Data)**: Define structured and clean data and evolve with the requirements. The given data is enriched with a schema with required columns only. The representation of this layer is prefixed with the `sta_` schema in a data warehouse.  De-Duplication is being performed here in this layer. The data is integrated as an Incremental Approach daily date-wise checkpoint in `sta_ ` and guarantees uniqueness on daily integrated data. Furthermore this is our main layer where we remove all the PII data due to GDPR constraints.

**Gold Layer (Business Level Aggregation)**: Deliver incrementally clean aggregated data to the downstream application. The enriched schema from the Silver `sta_` schema is used as a source to generate analytical metrics. The gold layer represents `stg_` as a prefix for the dwh schema.

####  Core Architecture Strategy:
Here, we explain the core component and our strategy to design a cost-effective solution. 
**Deta Lake**: Serves as the core centralised storage layer, offering ACID transactions and scalable metadata handling to unify streaming and batch data workflows and we could achieve this via open source Delta Lake or Iceberg file storage foramt instead of regular Parquet file.

**AWS Integration**: Leverages AWS's ecosystem, including Amazon S3 for resilient data storage, AWS Glue Python Shell for ETL and AWS Data Catalog, Redshift for BI analytics and AWS Glue Pyspark handling big data workloads. 

**Datawarehouse** Redshift could be our initial solution to enable the business intelligence metrics. 

**Data Ingestion Strategy**: This strategy employs scalable mechanisms to ingest data from diverse sources, ensuring robustness and reliability. Our primary data sources are product data, and we expect to integrate more data sources, such as click-stream events, marketing data, financial data and analytical dataset, etc., with time. We heavily rely on incremental data load process for better performance. Airbyte provides the flexibility to syncrhonize the data from Production database as a CDC and integrate data incrementally. It supports hundreds of connector out of the box including fetching data from thrid party sources APIs etc.

**Data Transformation Strategy**
Data Transformation: DBT is one of transformation tool which we can use to take the benefit to run the dwh model and incrementally synchronize the data from `sta_` to `stg_` layers. It could also allow us to generate the dwh model documetation for better data lineage in order to better design and development of complex KPIs metrics.

***Data Orchestrations** : We will use AWS Airflow Managed Workflow orchestration to schedule the pipeline.

The below architecture diagram presents the proposed architecture with the technologies

![archiectured_tools.png](images%2Farchiectured_tools.png)

# 2. MVP Solution for POC: 
Until now, we have discussed what is the best possible way for us to developed the end to end data platform that will benefit us. Now this MVP solution is custom design solution specially for this Technical Solution deliverable that will be able to run locally without the need of extra AWS Resources or services.
Now the architecture of this POC is look like this.
Instead of Airbyte and DBT we could use this solution to integrate the data to DWH directly.

### Pre-Requisite:
Disclaimer: This project is developed in MacOS you might need to change some scripts based on your OS.
You need following tools to run this project. 
    1. Docker 
    2. Makefile (https://gnuwin32.sourceforge.net/packages/make.htm)
    
### Data Sources:
Currently, we are expecting our data coming from live database _(consider PostgresDB imaginary)_ from product and engineering team. The data is provided in .csv files, but we have prepared the docker-compose script that load the data into PostgresSQL database `tcc` automatically as soon as we start the docker and mimic or work as a Production source databse for us. In below #Setup section you will find the details how to start the project.
Thus consider that currently we have that coming from PostgreSQL Production source named as `tcc` which is running locally for us using docker file

### Choice of Technologies:
Python is used to implement the Data Integration in all these three layers PostgresSQL used here for local development and testing here AWS Redshift. Due to limited personal account access to AWS, I decided to use PostgreSQL which we can deploy locally via Docker and run and test the application. However, in current development switching to a different DWH will be straightforward and configurable via config_prod.json.  For the DWH Serving Layer Jupyter is used to provide low-level SQL Engine on top of PostgresSQL. 
However, in order to enable CTO or Higher level management to access of Self-Service BI for the production we should create a dashboard using BI-Tool like Metabase/Tableau/AWS-Quicksight as we discussed in earlier section.

![archiecture_developed.png](images%2Farchiecture_developed.png)

### DWH Design
These dwh layers are created based on the following required dwh metrics using STAR Schema Model. We use the Star Schema because it simplifies the complex database queries by organizing data into fact and dimension tables, optimizing performance and readability for analytical processing, and enabling efficient retrieval of large volumes of data through straightforward and intuitive queries.
Our BI Workload are as follows:
1. Order Intake and revenue by shop, location, and time.
2. The drop-off rate from intake to eventual revenue.
3. Lag time from purchase to shipping.
4. Absolute and relative new and returning customers over time.
 

Considering these statements, I have created the following data model which will simplify the analysis.

### Conceptual Start Schema Data Model
To answer the analytical queries, The dimension and fact models are as follows:

**Fact Tables:**
fact_orders: This will contain order-level information.
fact_order_positions: This will contain order positions details, linking to individual products within an order.
**Dimension Tables:**
dim_customers: Information about customers.
dim_products: Details about products.
dim_shops: Information about shops.
dim_time: A time dimension table to allow for time-based analysis.

### DWH Model Considerations:
Revenue calculated as `price * quantity` when delivery_date is not null
Order Intake calculates as `price * quantity` without considering of delivery date
Thus fact_orders created while considering for each order,shop, customer and calculate the reveneue and order_intake as describe above.

#### Logical Model:
Define relationships between the fact tables and dimension tables is defined in the following diagram

![erd_diagram.png](images%2Ferd_diagram.png)


**Data Integration Medallion Architecture**
Data Pipeline is developed in Python which is able to run via docker locally. 
The OOP Development Paradigm used for the implementation because it is the best favour to design the the Raw,Sta and Stg Layer of data pipeline in their respective Classes. Based on this generalized classes we can add as many jobs easily.

Incremental Loading and Idempotency:
1. Each Pipeline implemented as an Incremental Data Loading
2. Create a checkpoint storage where the last successful date will 
3. Ensure the idempotency of the pipeline and make sure pipeline is not running twice

#### Project Structure:
The Project directory describes as follows

```
tcc-data-challenge
    |__data
        |__customers.csv
        |__order_positions.csv
        |__orders.csv
        |__products.csv        
    |__data_integration         # Python Project for Data Inegration
    |__database                 # Shared database directory for data integration project and for data analysis (notebook)
    |__images                   # images used in Readme.md
    |__notebook                 # notebook used as a Dashbaord builder
    |__Dockerfile               # Dockerfile for Python Data Integration Project
    |__docker-compose           # docker-compose postgres src and dwh databases
    |__Makefile                 # Makefile
    |__README.md                # Solution Description in .md
    
```

#### Data Integration
This is main Python based jobs implementation
```
data-integration
    |__config           # Extracted main data source directory in .json format
        |__config.json
        |__config_prod.json
    |__jobs
        |__raw_customers
        |__raw_order_positions
        |__raw_orders
        |__raw_products
        |__raw_shops
        |__sta_customers
        |__sta_order_positions
        |__sta_orders
        |__sta_products
        |__sta_shops
        |__stg_fact_ordes_positions
        |__stg_fact_orders
        |__stg_time
  
```

#### Project Execution in Action:

1. Pre-Requisites: `make`, `docker` and `docker-compose` is required to run this project in local.

2. First of all download the .zip data from here extract it to `data/` folder. This .zip file need to extracted. Check above the `data/` directory structure we need data in this format

3. Start Infrastructure PostgreSQL and Jupyter Notebook. The Mimic src `tcc` database imported with csv file data and `dwh` automatically create with this following command

```
make deploy-local-infra
```

Please wait until the PostgrsSQL container state change to `running` 

1. Then run python job locally via `make run-local`. This will run all jobs and will took ~1-2 minutes to execute.
2. Now got to Jupyter Notebook using this url http://localhost:9999/lab/tree/data_analysis.ipynb
3. Here you will see the queries for defined analysis for CTO

### 3. Future Work 
1. Add Include Location Dimension in order to properly drill-down the metrics geographically.
2. Implementation of Unit Testing for Python Jobs
3. Parameterized the main.py function to run one specific job via docker container
4. Implementation of data contracts in order to detect the schema changes on the fly create a monitoring and alerting. In order to make sure that the source database are stable and we detect changes automatically as soon as they change it
5. Logging and Monitoring of Pipeline Failure and data-contracts alerts 
6. Deploy or execute the code via Orchestration tool like Airflow 
7. Implementation of CI/CD pipeline to deploy new job to airflow Dags

