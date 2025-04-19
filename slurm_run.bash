#!/bin/bash

#SBATCH --account=c01500
#SBATCH --partition=gpu-debug
#SBATCH --gres=gpu:1
#SBATCH --time=00:59:00
#SBATCH --mem=32G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --job-name=dialect_py27
#SBATCH --output=logs/debug_%j.out
#SBATCH --error=logs/debug_%j.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=zz79@iu.edu

set -euo pipefail
cd $SLURM_SUBMIT_DIR
mkdir -p logs

echo "🚗 Loading Python 2.7 module..."
module purge
module load PrgEnv-gnu
module load python/2.7.18
module load gcc

echo "🧼 Cleaning old env..."
rm -rf venv tools get-pip.py

echo "🛠️ Installing virtualenv locally..."
python -m ensurepip || true
curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py
python get-pip.py --force-reinstall
python -m pip install --no-cache-dir --target=tools virtualenv

echo "🌱 Creating Python 2.7 virtualenv..."
python ./tools/virtualenv venv

source venv/bin/activate

echo "📦 Installing Python 2.7 compatible libraries..."
pip install --no-cache-dir tensorflow==1.15 sox==1.3.2 librosa==0.5.1 numpy scipy

echo "📋 Installed packages:"
pip list

echo "🚀 Running your pipeline..."
bash run.sh

echo "✅ Job finished at $(date)"
