# Doing performance benchmark

> Note: This benchmark approach is opinionated. There has to be better benchmark process out there. However, this is just to give high level summary how the application performs and what does it consume to offer such performance.

## Steps

1. After cloning the repository to `REPO_DIR` and `cd`-ing,
2. Run the following to execute CLI performance test
   ```sh
   docker-compose run --rm cli profiling:cli
   ```

3. And/or, run the following to execute API performance test
   ```sh
   docker-compose run --rm benchmark
   ```
