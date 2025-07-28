# Personal RAG Agent Module

*Retrieval-Augmented Generation System for Personal Document Management*

## Overview

The Personal RAG Agent is an intelligent document processing and retrieval system that combines the power of vector embeddings with large language models to create a personal knowledge base. It automatically ingests, processes, and indexes documents, making them searchable through natural language queries.

## Business Context

**Problem Solved**: Managing and retrieving information from large collections of personal documents, research papers, notes, and web content is time-consuming and inefficient with traditional search methods.

**Solution**: This RAG system creates semantic embeddings of your documents, enabling intelligent search and retrieval based on meaning rather than just keywords. It can answer questions, summarize content, and provide contextual information from your personal knowledge base.

## System Architecture

```
Document Input → Text Extraction → Chunking → Embedding Generation
                                                      ↓
PostgreSQL + pgvector ← Vector Storage ← Embedding Model
                                                      ↓
Query Input → Query Embedding → Similarity Search → Context Retrieval
                                                      ↓
LLM (Ollama/OpenAI) ← Context + Query → Generated Response
```

## Prerequisites

### Required Services and Infrastructure

1. **PostgreSQL Database with pgvector Extension**
   - PostgreSQL 12+ with pgvector extension installed
   - Database with appropriate permissions
   - Connection string and credentials

2. **Embedding Model Service**
   - **Option A**: Local Ollama instance with embedding models
   - **Option B**: OpenAI API for embeddings
   - **Option C**: Hugging Face embedding models

3. **Large Language Model**
   - **Option A**: Local Ollama with LLM models (Llama 3, Mistral, etc.)
   - **Option B**: OpenAI GPT models
   - **Option C**: Other API-based LLM services

4. **Document Processing Tools**
   - PDF processing capabilities
   - Web scraping tools
   - Text extraction utilities

### Environment Variables

Add these to your `.env` file:

```bash
# PostgreSQL Configuration
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_DB=rag_database
POSTGRES_USER=your_username
POSTGRES_PASSWORD=your_password
POSTGRES_CONNECTION_STRING=postgresql://user:pass@localhost:5432/rag_database

# Embedding Model Configuration
EMBEDDING_MODEL_TYPE=ollama  # or openai, huggingface
OLLAMA_BASE_URL=http://localhost:11434
OPENAI_API_KEY=your_openai_api_key
EMBEDDING_MODEL_NAME=nomic-embed-text  # or text-embedding-ada-002

# LLM Configuration
LLM_TYPE=ollama  # or openai
LLM_MODEL_NAME=llama3  # or gpt-3.5-turbo
LLM_BASE_URL=http://localhost:11434

# Document Processing
MAX_CHUNK_SIZE=1000
CHUNK_OVERLAP=200
SIMILARITY_THRESHOLD=0.7
```

## Installation and Setup

### Step 1: Database Setup

1. **Install PostgreSQL with pgvector**:
   ```sql
   -- Connect to your PostgreSQL instance
   CREATE EXTENSION IF NOT EXISTS vector;
   
   -- Create the documents table
   CREATE TABLE documents (
       id SERIAL PRIMARY KEY,
       title VARCHAR(255),
       content TEXT,
       source_url VARCHAR(500),
       document_type VARCHAR(50),
       chunk_index INTEGER,
       embedding vector(1536),  -- Adjust dimension based on your model
       metadata JSONB,
       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
   );
   
   -- Create index for vector similarity search
   CREATE INDEX ON documents USING ivfflat (embedding vector_cosine_ops)
   WITH (lists = 100);
   ```

2. **Verify pgvector installation**:
   ```sql
   SELECT * FROM pg_extension WHERE extname = 'vector';
   ```

### Step 2: Local AI Setup (Ollama)

1. **Install Ollama**:
   - Download from [ollama.ai](https://ollama.ai)
   - Install and start the service

2. **Pull required models**:
   ```bash
   # Embedding model
   ollama pull nomic-embed-text
   
   # Language model
   ollama pull llama3
   # or
   ollama pull mistral
   ```

3. **Verify Ollama is running**:
   ```bash
   curl http://localhost:11434/api/tags
   ```

### Step 3: Import Workflows

1. Open your n8n instance
2. Navigate to Workflows → Import from File
3. Import both workflow files:
   - `A1_Adding_Storing_Files_In_PostgresDB.json` (Document Ingestion)
   - `A2_PA_Scrapes_Documents.json` (Web Scraping)

### Step 4: Configure n8n Credentials

1. **PostgreSQL Credential**:
   - Create new PostgreSQL credential
   - Enter connection details
   - Test connection

2. **Ollama Configuration**:
   - No credentials needed for local Ollama
   - Ensure base URL is correct (http://localhost:11434)

3. **OpenAI Credential** (if using OpenAI):
   - Create OpenAI credential
   - Enter API key
   - Select appropriate models

### Step 5: Configure Workflows

1. **Document Ingestion Workflow (A1)**:
   - Update PostgreSQL connection settings
   - Configure embedding model parameters
   - Set chunking parameters
   - Customize document processing logic

2. **Web Scraping Workflow (A2)**:
   - Configure target websites
   - Set scraping parameters
   - Update content extraction rules
   - Configure storage settings

## How to Run and Test

### Testing Document Ingestion

1. **Activate the Document Ingestion Workflow**
2. **Prepare test documents**:
   - PDF files
   - Text documents
   - Web URLs
3. **Trigger the workflow**:
   - Upload documents via webhook
   - Or manually execute with test data
4. **Verify ingestion**:
   - Check PostgreSQL for new records
   - Verify embeddings are generated
   - Test similarity search queries

### Testing Web Scraping

1. **Activate the Web Scraping Workflow**
2. **Configure target URLs**
3. **Run the workflow**:
   - Monitor scraping progress
   - Check for successful content extraction
4. **Verify storage**:
   - Confirm documents in PostgreSQL
   - Test retrieved content quality

### Testing RAG Queries

1. **Create a query workflow** or use n8n's manual execution
2. **Test queries**:
   ```javascript
   // Example query
   {
     "query": "What are the main benefits of vector databases?",
     "max_results": 5,
     "similarity_threshold": 0.7
   }
   ```
3. **Verify responses**:
   - Check similarity scores
   - Evaluate response quality
   - Test different query types

## Configuration Options

### Chunking Strategy

Customize document chunking in the ingestion workflow:

```javascript
// Chunk configuration
const chunkSize = 1000;  // Characters per chunk
const chunkOverlap = 200;  // Overlap between chunks
const separators = ['\n\n', '\n', '. ', ' '];  // Split priorities
```

### Embedding Models

Choose embedding model based on your needs:

| Model | Dimension | Use Case | Performance |
|-------|-----------|----------|-------------|
| nomic-embed-text | 768 | General purpose | Fast, local |
| text-embedding-ada-002 | 1536 | High quality | Slower, API cost |
| all-MiniLM-L6-v2 | 384 | Lightweight | Very fast |

### Similarity Search Parameters

Fine-tune search behavior:

```javascript
// Search configuration
const similarityThreshold = 0.7;  // Minimum similarity score
const maxResults = 10;  // Maximum documents to retrieve
const searchType = 'cosine';  // cosine, euclidean, or dot_product
```

## Best Practices

### Document Preparation
- Clean and preprocess documents before ingestion
- Use consistent formatting
- Include metadata for better organization
- Remove irrelevant content (headers, footers)

### Chunking Strategy
- Balance chunk size vs. context preservation
- Use semantic boundaries (paragraphs, sections)
- Maintain overlap for context continuity
- Test different strategies for your content type

### Vector Search Optimization
- Regularly update vector indexes
- Monitor query performance
- Adjust similarity thresholds based on results
- Use appropriate distance metrics

### Model Selection
- Local models for privacy and cost control
- API models for higher quality when needed
- Consider model size vs. performance trade-offs
- Regularly update models for improvements

## Troubleshooting

### Common Issues and Solutions

#### Issue: "different vector dimensions" error
**Cause**: Mixing embeddings from different models with different dimensions
**Solution**:
1. Ensure consistent embedding model usage
2. Update table schema to match model dimensions:
   ```sql
   ALTER TABLE documents ALTER COLUMN embedding TYPE vector(768);
   ```
3. Re-generate all embeddings with the same model

#### Issue: Poor search results
**Cause**: Inappropriate chunking or similarity thresholds
**Solution**:
1. Experiment with different chunk sizes
2. Adjust similarity threshold (0.6-0.8 typically works well)
3. Try different embedding models
4. Improve document preprocessing

#### Issue: Slow query performance
**Cause**: Missing or inefficient vector indexes
**Solution**:
1. Create appropriate vector indexes:
   ```sql
   CREATE INDEX ON documents USING ivfflat (embedding vector_cosine_ops)
   WITH (lists = 100);
   ```
2. Increase `lists` parameter for larger datasets
3. Consider HNSW index for better performance:
   ```sql
   CREATE INDEX ON documents USING hnsw (embedding vector_cosine_ops);
   ```

#### Issue: Ollama connection failures
**Cause**: Ollama service not running or incorrect configuration
**Solution**:
1. Verify Ollama is running: `ollama list`
2. Check service status and restart if needed
3. Verify model availability: `ollama pull model-name`
4. Test API endpoint: `curl http://localhost:11434/api/tags`

#### Issue: PostgreSQL connection errors
**Cause**: Database configuration or permission issues
**Solution**:
1. Verify connection string format
2. Check database permissions
3. Ensure pgvector extension is installed
4. Test connection outside n8n

### Debugging Steps

1. **Check workflow execution logs**:
   - Monitor n8n execution history
   - Look for error messages in individual nodes
   - Verify data flow between nodes

2. **Database verification**:
   ```sql
   -- Check document count
   SELECT COUNT(*) FROM documents;
   
   -- Verify embeddings
   SELECT id, title, array_length(embedding, 1) as dimension 
   FROM documents LIMIT 5;
   
   -- Test similarity search
   SELECT title, 1 - (embedding <=> '[0.1,0.2,...]'::vector) as similarity 
   FROM documents 
   ORDER BY embedding <=> '[0.1,0.2,...]'::vector 
   LIMIT 5;
   ```

3. **Model testing**:
   ```bash
   # Test Ollama embedding
   curl http://localhost:11434/api/embeddings -d '{
     "model": "nomic-embed-text",
     "prompt": "test query"
   }'
   
   # Test Ollama generation
   curl http://localhost:11434/api/generate -d '{
     "model": "llama3",
     "prompt": "Hello, world!"
   }'
   ```

## Performance Optimization

### Database Optimization

1. **Index Strategy**:
   ```sql
   -- For large datasets, use HNSW index
   CREATE INDEX ON documents USING hnsw (embedding vector_cosine_ops);
   
   -- Add indexes on frequently queried columns
   CREATE INDEX ON documents(document_type);
   CREATE INDEX ON documents(created_at);
   ```

2. **Query Optimization**:
   ```sql
   -- Use LIMIT to control result size
   SELECT * FROM documents 
   ORDER BY embedding <=> $1 
   LIMIT 10;
   
   -- Add WHERE clauses to filter before similarity search
   SELECT * FROM documents 
   WHERE document_type = 'pdf'
   ORDER BY embedding <=> $1 
   LIMIT 10;
   ```

### Memory Management

1. **Chunk Size Optimization**:
   - Smaller chunks: Better precision, more storage
   - Larger chunks: Better context, less storage
   - Test with your specific content type

2. **Batch Processing**:
   - Process documents in batches
   - Use connection pooling
   - Implement retry logic for failures

## Security Considerations

### Data Protection
- Encrypt sensitive documents before processing
- Use secure database connections (SSL)
- Implement access controls on the database
- Regular security updates for all components

### Privacy
- Keep embeddings and documents on local infrastructure
- Avoid sending sensitive data to external APIs
- Implement data retention policies
- Consider anonymization for sensitive content

## Future Enhancements

### Planned Improvements

1. **Multi-modal Support**:
   - Image document processing (OCR)
   - Audio transcription and indexing
   - Video content extraction

2. **Advanced RAG Techniques**:
   - Hierarchical retrieval
   - Query expansion and rewriting
   - Multi-step reasoning

3. **User Interface**:
   - Web-based query interface
   - Document management dashboard
   - Analytics and insights

4. **Integration Enhancements**:
   - Real-time document monitoring
   - Email and messaging integration
   - API endpoints for external access

### Scalability Considerations

- Implement horizontal scaling for PostgreSQL
- Add caching layer for frequent queries
- Consider distributed vector databases
- Implement load balancing for high availability

---

*This Personal RAG Agent module provides a foundation for building sophisticated document intelligence systems. It combines the latest advances in vector databases and language models to create a powerful personal knowledge assistant.*