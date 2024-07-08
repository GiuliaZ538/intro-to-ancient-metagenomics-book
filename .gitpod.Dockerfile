FROM gitpod/workspace-base

# Fix systemd conflict with timedatectl during tidyverse installation
ENV TZ=UTC

# Return in installation
USER gitpod

## Install base R and the various packages _required_ for the tidyverse and quarto rendering
RUN sudo apt update
RUN sudo apt install -y cmake gfortran
RUN sudo apt install -y libharfbuzz-dev libfribidi-dev librsvg2-bin pip && sudo apt autoremove -y

RUN sudo apt update -qq
RUN wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
RUN sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
RUN sudo apt install -y r-base-dev

## Install the various R packages used for the textbook (not necessarily the practicals!)
RUN sudo Rscript -e 'install.packages("rmarkdown", repos="https://cloud.r-project.org")'
RUN sudo Rscript -e 'install.packages("languageserver", repos="https://cloud.r-project.org")'
RUN sudo Rscript -e 'install.packages("Rsamtools", repos="https://cloud.r-project.org")'
RUN sudo Rscript -e 'install.packages("cuperdec", repos="https://cloud.r-project.org")'
RUN sudo Rscript -e 'install.packages("viridis", repos="https://cloud.r-project.org")'
RUN sudo Rscript -e 'install.packages("pander", repos="https://cloud.r-project.org")'
RUN sudo Rscript -e 'install.packages("ggrepel", repos="https://cloud.r-project.org")'
RUN sudo Rscript -e 'install.packages("tidyverse", repos="https://cloud.r-project.org")'
RUN sudo Rscript -e 'install.packages("ggpubr", repos="https://cloud.r-project.org")'
RUN sudo Rscript -e 'install.packages("gt", repos="https://cloud.r-project.org")'

## Install jupyter for python code sections
RUN python3 -m pip install jupyter

## Install quarto and tinytext to allow PDf rendering
RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.4.553/quarto-1.4.553-linux-amd64.deb
RUN sudo dpkg -i quarto*
RUN rm *.deb
RUN quarto install tinytex
