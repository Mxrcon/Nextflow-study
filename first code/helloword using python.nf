#!/usr/bin/env nextflow

process printing {
  script:
    """
    #!/usr/bin/python3

    print("Hello word!")

    """
}
