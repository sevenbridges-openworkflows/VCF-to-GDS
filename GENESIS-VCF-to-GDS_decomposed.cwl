dct:creator:
  "@id": "sbg"
  foaf:name: SevenBridges
  foaf:mbox: "mailto:support@sbgenomics.com"
$namespaces:
  sbg: https://sevenbridges.com
  dct: http://purl.org/dc/terms/
  foaf: http://xmlns.com/foaf/0.1/

class: Workflow
cwlVersion: v1.1
doc: |-
  **VCF to GDS** workflow converts VCF or BCF files into Genomic Data Structure (GDS) format. GDS files are required by all workflows utilizing the GENESIS or SNPRelate R packages.

  Step 1 (*VCF to GDS*) converts  VCF or BCF files (one per chromosome) into GDS files, with option to keep a subset of **Format** fields (by default only *GT* field). (BCF files may be used instead of  VCF.) 

  Step 2 (Unique Variant IDs) ensures that each variant has a unique integer ID across the genome. 

  Step 3 (Check GDS) ensures that no important information is lost during conversion. If Check GDS fails, it is likely that there was an issue during the conversion.
  **Important note:** This step can be time consuming and therefore expensive. Also, failure of this tool is rare. For that reason we allows this step to be optional and it's turned off by default. To turn it on check yes at *check GDS* port. For information on differences in execution time and cost of the same task with and without check GDS  please refer to Benchmarking section.  

  ### Common use cases
  This workflow is used for converting VCF files to GDS files.

  ### Common issues and important notes
  * This pipeline expects that input **Variant files** are separated to be per chromosome and that files are properly named.  It is expected that chromosome is included in the file name in following format:  chr## , where ## is the name of the chromosome (1-24 or X, Y). Chromosome can be included at any part of the filename. Inputs can be in vcf, vcf.gz and bcf format.  Examples: Data_subset_chr1.vcf, Data_subset_chr1.vcf.gz, Data_chr1_subset.vcf, Data_subset_chr1.bcf. 



  * **Number of CPUs** parameter should only be used when working with VCF files. The workflow is unable to utilize more than one thread when working with BCF files, and will fail if number of threads is set for BCF conversion.

  * **Note:** Variant IDs in output workflow might be different than expected. Unique variants are assigned for one chromosome at a time, in ascending, natural order (1,2,..,24 or X,Y). Variant IDs are integer IDs unique to your data and do not map to *rsIDs* or any other standard identifier. Be sure to use *variant_id* file for down the line workflows generated based on GDS files created by this workflow.

  * **Note** This workflow has not been tested on datasets containing more than 62k samples. Since *check_gds* step is very both ram and storage memory demanding, increasing sample count might lead to task failure. In case of any task failure, feel free to contact our support.

  * **Note** **Memory GB** should be set when working with larger number of samples (more than 10k). During benchmarking, 4GB of memory were enough when working with 50k samples. This parameter is related to *VCF to GDS* step, different amount of memory is used in other steps.


  ### Changes introduced by Seven Bridges
  Final step of the workflow is writing checking status to stderr, and therefore it is stored in *job_err.log*, available in the platform *task stats and logs page*. If workflow completes successfully, it means that validation has passed, if workflow fails on *check_gds* step, it means that validation failed.

  ### Performance Benchmarking

  In the following table you can find estimates of running time and cost. 
        

  | Sample Count &nbsp; &nbsp; &nbsp;  | Input &nbsp; &nbsp;  || Check GDS  &nbsp; &nbsp; &nbsp;  | Instance type &nbsp; &nbsp; &nbsp;  | Spot/On Dem.  &nbsp; &nbsp; &nbsp; |CPU  &nbsp; &nbsp; &nbsp;  | RAM  &nbsp; &nbsp; &nbsp;  | Time  &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;| Cost |
  |--------------------|----------------------------|-------------|---------------------|------------------------|-----|----|------|-----|-----|
  | 2.5k samples  | vcf.gz  |                     | Yes  |  c5.18.xlarge | Spot     |1  | 4   | 1 h, 16 min   | $5  |
  | 2.5k samples  | vcf.gz  |                     | No  |  c5.18.xlarge | Spot     |1  | 4   | 34 min   | $1  |
  | 10k samples  | vcf.gz  |                     | Yes  |  c5.9xlarge | On Demand     |1  | 4   | 1 d, 4 h   | $170  |
  | 10k samples  | vcf.gz  |                     | No  |  c5.18xlarge | Spot     |1  | 4   | 5 h, 50 min   | $8  |
  | 36k samples  | vcf.gz  |                     | Yes  |  c4.8xlarge | On Demand     |1  | 4   | 5 d   | $730  |
  | 36k samples  | vcf.gz  |                     | Yes  |  c5.9xlarge | On Demand     |1  | 4   | 5 d   | $460  |
  | 36k samples  | vcf.gz  |                     | No  |  c5.9xlarge | On Demand     |1  | 4   | 17 h   | $45  |
  | 36k samples  | vcf.gz  |                     | No  |  m5.4xlarge | On Demand     |1  | 4   | 1 d, 3h   | $43  |
  | 50k samples  | vcf.gz  |                     | Yes  |  c4.8xlarge | On Demand     |1  | 4   | 6 d   | $1150  |
  | 50k samples  | vcf.gz  |                     | Yes  |  c5.9xlarge | On Demand     |1  | 4   | 5 d   | $725  |
  | 50k samples  | vcf.gz  |                     | No  |  c5.9xlarge | On Demand     |1  | 4   | 1 d, 7 h   | $77  |
  | 50k samples  | bcf  |                     | No  |  c5.18xlarge | On Demand     |1  | 4   | 1 d, 11 h   | $110  |
  | 2.5k samples  | vcf.gz  |                     | Yes  |  n1-standard-64 | Preemptible     |1  | 4   | 1 h, 30 min   | $7  |
  | 2.5k samples  | vcf.gz  |                     | No  |  n1-highmem-32 | Preemptible     |1  | 4   | 47 min   | $1  |
  | 10k samples  | vcf.gz  |                     | Yes  |  n1-standard-16 | On Demand     |1  | 4   | 1 d, 16 h   | $130  |
  | 10k samples  | vcf.gz  |                     | No  |  n1-highmem-32 | Preemptible    |1  | 4   | 8 h   | $5  |
  | 36k samples  | vcf.gz  |                     | No  |  n1-standard-16 | On Demand     |1  | 4   | 1 d,  9h   | $45  |
  | 50k samples  | vcf.gz  |                     | No  |  n1-standard-16 | On Demand     |1  | 4   | 2 d, 7 h   | $75  |
  | 50k samples  | bcf  |                     | No  |  n1-standard-64| On Demand     |1  | 4   | 2 d, 7 h   | $180  |  <br>;


  *For more details on **spot/preemptible instances** please visit the [Knowledge Center](https://docs.sevenbridges.com/docs/about-spot-instances).*      

  **Note** Both at 50k samples, and 62k samples, termination of spot instance occurred, leading to higher duration and final cost. These results are not removed from benchmark as this behavior is usual and expected, and should be taken into account when using spot instances.


  ### API Python Implementation

  The app's draft task can also be submitted via the **API**. In order to learn how to get your **Authentication token** and **API endpoint** for the corresponding Platform visit our [documentation](https://github.com/sbg/sevenbridges-python#authentication-and-configuration).

  ```python
  from sevenbridges import Api

  authentication_token, api_endpoint = "enter_your_token", "enter_api_endpoint"
  api = Api(token=authentication_token, url=api_endpoint)
  # Get project_id/app_id from your address bar. Example: https://f4c.sbgenomics.com/u/your_username/project/app
  project_id, app_id = "your_username/project", "your_username/project/app"
  # Get file names from files in your project. Example: Names are taken from Data/Public Reference Files.
  inputs = {
      "input_gds_files": api.files.query(project=project_id, names=["basename_chr1.gds", "basename_chr2.gds", ..]),
      "phenotype_file": api.files.query(project=project_id, names=["name_of_phenotype_file"])[0],
      "null_model_file": api.files.query(project=project_id, names=["name_of_null_model_file"])[0]
  }
  task = api.tasks.create(name='Single Variant Association Testing - API Run', project=project_id, app=app_id, inputs=inputs, run=False)
  ```
  Instructions for installing and configuring the API Python client, are provided on [github](https://github.com/sbg/sevenbridges-python#installation). For more information about using the API Python client, consult [sevenbridges-python documentation](http://sevenbridges-python.readthedocs.io/en/latest/). **More examples** are available [here](https://github.com/sbg/okAPI).

  Additionally, [API R](https://github.com/sbg/sevenbridges-r) and [API Java](https://github.com/sbg/sevenbridges-java) clients are available. To learn more about using these API clients please refer to the [API R client documentation](https://sbg.github.io/sevenbridges-r/), and [API Java client documentation](https://docs.sevenbridges.com/docs/java-library-quickstart).
label: VCF to GDS
$namespaces:
  sbg: https://sevenbridges.com
inputs:
- id: memory_gb
  type: float?
  label: Memory GB
  doc: Memory to allocate per job. For low number of samples (up to 10k), 1GB is usually
    enough. For larger number of samples, value should be set higher (50k samples
    ~ 4GB).
  sbg:toolDefaultValue: '4'
  sbg:x: -474
  sbg:y: -226
- id: cpu
  type: int?
  label: Number of CPUs
  doc: Number of CPUs to use per job.
  sbg:toolDefaultValue: '1'
  sbg:x: -560.6575927734375
  sbg:y: -5.473904132843018
- id: vcf_file
  sbg:fileTypes: VCF, VCF.GZ, BCF, BCF.GZ
  type: File[]
  label: Variant Files
  doc: Input Variants Files.
  sbg:x: -474.484375
  sbg:y: 108.5
- id: format
  type: string[]?
  label: Format
  doc: VCF Format fields to keep in GDS file.
  sbg:toolDefaultValue: GT
  sbg:x: -560
  sbg:y: -143
- id: check_gds_1
  type:
  - 'null'
  - type: enum
    symbols:
    - Yes
    - No
    name: check_gds
  label: Check GDS
  doc: Choose “Yes” to check for conversion errors by comparing all values in the
    output GDS file against the input files. The total cost of the job will be ~10x
    higher if check GDS is “Yes”.
  sbg:toolDefaultValue: No
  sbg:x: -0.984375
  sbg:y: 141.5
outputs:
- id: unique_variant_id_gds_per_chr
  outputSource:
  - unique_variant_id/unique_variant_id_gds_per_chr
  sbg:fileTypes: GDS
  type: File[]?
  label: GDS files with unique variant IDs
  doc: GDS files in which each variant has a unique identifier across the entire genome.
    For example, if chromosome 1 has 100 variants and chromosome 2 has 100 variants,
    the variant.id field will contain 1:100 in the chromosome 1 file and 101:200 in
    the chromosome 2 file.
  sbg:x: 115
  sbg:y: -211
steps:
  vcf2gds:
    in:
    - id: vcf_file
      source: vcf_file
    - id: memory_gb
      source: memory_gb
    - id: cpu
      source: cpu
    - id: format
      source:
      - format
    out:
    - id: gds_output
    - id: config_file
    run: steps/vcf2gds.cwl
    label: vcf2gds
    scatter:
    - vcf_file
    sbg:x: -297
    sbg:y: -31
  unique_variant_id:
    in:
    - id: gds_file
      source:
      - vcf2gds/gds_output
    out:
    - id: unique_variant_id_gds_per_chr
    - id: config
    run: steps/unique_variant_id.cwl
    label: Unique Variant ID
    sbg:x: -107
    sbg:y: -95
  check_gds:
    in:
    - id: vcf_file
      source:
      - vcf_file
    - id: gds_file
      source: unique_variant_id/unique_variant_id_gds_per_chr
    - id: check_gds
      source: check_gds_1
    out: []
    run: steps/check_gds.cwl
    label: Check GDS
    scatter:
    - gds_file
    sbg:x: 113
    sbg:y: 22
hints:
- class: sbg:AWSInstanceType
  value: c5.18xlarge;ebs-gp2;700
- class: sbg:maxNumberOfParallelInstances
  value: '5'
requirements:
- class: ScatterFeatureRequirement
- class: InlineJavascriptRequirement
- class: StepInputExpressionRequirement
sbg:projectName: GENESIS pipelines - DEMO
sbg:revisionsInfo:
- sbg:revision: 0
  sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1571921336
  sbg:revisionNotes: Copy of boris_majic/genesis-pipelines-dev/vcf-to-gds/6
- sbg:revision: 1
  sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1574269210
  sbg:revisionNotes: Copy of boris_majic/genesis-pipelines-dev/vcf-to-gds/10
- sbg:revision: 2
  sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1580990742
  sbg:revisionNotes: Copy of boris_majic/genesis-pipelines-dev/vcf-to-gds/15
- sbg:revision: 3
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1583937356
  sbg:revisionNotes: Copy of boris_majic/genesis-pipelines-dev/vcf-to-gds/24
- sbg:revision: 4
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1584372245
  sbg:revisionNotes: Final wrap
- sbg:revision: 5
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1590669659
  sbg:revisionNotes: parseInt replaced with parseFloat
- sbg:revision: 6
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1591620043
  sbg:revisionNotes: VCF file type updated
- sbg:revision: 7
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1593599782
  sbg:revisionNotes: 'New docker image: 2.8.0'
- sbg:revision: 8
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1593616250
  sbg:revisionNotes: Description update
- sbg:revision: 9
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1593692054
  sbg:revisionNotes: Input descriptions on nod level
- sbg:revision: 10
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1593698233
  sbg:revisionNotes: Input description updated
- sbg:revision: 11
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1596463030
  sbg:revisionNotes: Benchmarking updated
- sbg:revision: 12
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1600673096
  sbg:revisionNotes: Benchmarking table updated
- sbg:revision: 13
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602062049
  sbg:revisionNotes: Docker 2.8.1 and SaveLogs hint
- sbg:revision: 14
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602069512
  sbg:revisionNotes: SaveLogs update
- sbg:revision: 15
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602073860
  sbg:revisionNotes: Input descriptions updated
- sbg:revision: 16
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602073914
  sbg:revisionNotes: Input descriptions updated
- sbg:revision: 17
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1603717682
  sbg:revisionNotes: Config cleaning
- sbg:revision: 18
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1606725102
  sbg:revisionNotes: CWLtool compatible
sbg:image_url:
sbg:license: MIT
sbg:toolAuthor: TOPMed DCC
sbg:categories:
- GWAS
- VCF Processing
sbg:appVersion:
- v1.1
id: https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/boris_majic/genesis-pipelines-demo/vcf-to-gds/18/raw/
sbg:id: boris_majic/genesis-pipelines-demo/vcf-to-gds/18
sbg:revision: 18
sbg:revisionNotes: CWLtool compatible
sbg:modifiedOn: 1606725102
sbg:modifiedBy: dajana_panovic
sbg:createdOn: 1571921336
sbg:createdBy: boris_majic
sbg:project: boris_majic/genesis-pipelines-demo
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:contributors:
- dajana_panovic
- boris_majic
sbg:latestRevision: 18
sbg:publisher: sbg
sbg:content_hash: a44d3b7cb7c59afd951c0406b2b23c44ec37ae5a8c1e5f92c67b2554bc9131b46
