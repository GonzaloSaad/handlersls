import setuptools

__version__ = "0.0.1"

with open('README.md') as f:
    long_description = f.read()

with open('requirements.txt') as f:
    requirements = f.read().splitlines()

setuptools.setup(
    name='handlersls',
    version=__version__,
    author='GonzaloSaad',
    author_email='saad.gonzalo.ale@gmail.com',
    description="A python lib that provides handlers for serverless events",
    long_description=long_description,
    long_description_content_type='text/markdown',
    url='https://github.com/GonzaloSaad/handlersls',
    packages=setuptools.find_packages(),
    install_requires=requirements,
    classifiers=[],
)
