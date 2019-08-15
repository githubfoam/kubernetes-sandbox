    # Run end to end tests
    sonobuoy run --wait --skip-preflight
    # Fetch the results
    results=$(sonobuoy retrieve)
    # Extract to the host machine
    mkdir -p /vagrant/#{folder}
    tar xzf $results -C /vagrant/#{folder}
    # Print
    sonobuoy e2e $results
