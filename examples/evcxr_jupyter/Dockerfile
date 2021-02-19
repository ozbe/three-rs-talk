FROM jupyter/minimal-notebook

USER root

RUN apt-get update && apt-get install -yq --no-install-recommends \ 
  cmake \
  curl

USER $NB_UID

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --component rust-src
ENV PATH="${HOME}/.cargo/bin:${PATH}"
RUN cargo install evcxr_jupyter
RUN evcxr_jupyter --install

USER root

RUN apt-get remove -y --auto-remove \
  cmake \
  curl \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

USER $NB_UID