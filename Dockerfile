FROM rohanshahcsiro/mpmap2:latest

COPY packages.txt .

RUN apt-get update && cat packages.txt | xargs apt-get install -y --no-install-recommends \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/rohan-shah/mpMapInteractive2.git \
 && cd mpMapInteractive2 \ 
 && mkdir build \
 && cd build \ 
 && cmake -DCMAKE_BUILD_TYPE=Release .. -DRcpp_DIR=/Rcpp/build -DUSE_BOOST=On \
 && touch NAMESPACE && make && make install

# Install Tini
RUN wget --quiet https://github.com/krallin/tini/releases/download/v0.10.0/tini \
 && echo "1361527f39190a7338a0b434bd8c88ff7233ce7b9a4876f3315c22fce7eca1b0 *tini" | sha256sum -c - \
 && mv tini /usr/local/bin/tini \
 && chmod +x /usr/local/bin/tini

# Configure container startup
ENTRYPOINT ["tini", "--"]

# Overwrite this with 'CMD []' in a dependent Dockerfile
CMD ["/bin/bash"]
