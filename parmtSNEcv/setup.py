from setuptools import setup

def readme():
  with open('README.rst') as f:
    return f.read()

setup(name='parmtSNEcv',
      version='0.1',
      description='Parametric t-SNE using artificial neural networks for development of collective variables of molecular systems',
      long_description=readme(),
      classifiers=[
        'Development Status :: 2 - Pre-Alpha',
        'License :: OSI Approved :: MIT License',
        'Programming Language :: Python',
        'Topic :: Scientific/Engineering :: Artificial Intelligence',
        'Topic :: Scientific/Engineering :: Chemistry',
      ],
      keywords='artificial neural networks molecular dynamics simulation',
      url='https://github.com/spiwokv/parmtSNEcv',
      author='Vojtech Spiwok, ',
      author_email='spiwokv@vscht.cz',
      license='MIT',
      packages=['parmtSNEcv'],
      scripts=['bin/parmtSNEcv'],
      install_requires=[
          'numpy',
          'cython',
          'mdtraj==1.9.3',
          'keras==2.3.1',
          'argparse',
          'datetime',
          'codecov',
          'tensorflow==2.0.0',
          'pandas'
      ],
      include_package_data=True,
      zip_safe=False)


