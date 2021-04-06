class: CommandLineTool
cwlVersion: v1.1
$namespaces:
  sbg: https://sevenbridges.com
id: boris_majic/genesis-toolkit-demo/check_gds/12
baseCommand: []
inputs:
- sbg:category: Inputs
  id: vcf_file
  type: File[]
  label: Variants file
  doc: VCF or BCF files can have two parts split by chromosome identifier.
  sbg:fileTypes: VCF, VCF.GZ, BCF, BCF.GZ
- sbg:category: Input
  id: gds_file
  type: File
  label: GDS File
  doc: GDS file produced by conversion.
  sbg:fileTypes: gds
- sbg:category: Inputs
  id: sample_file
  type: File?
  label: Sample file
  doc: Sample file
- sbg:toolDefaultValue: No
  sbg:category: Inputs
  id: check_gds
  type:
  - 'null'
  - type: enum
    symbols:
    - Yes
    - No
    name: check_gds
  label: check GDS
  doc: Choose “Yes” to check for conversion errors by comparing all values in the
    output GDS file against the input files. The total cost of the job will be ~10x
    higher if check GDS is “Yes”.
outputs: []
label: check_gds
arguments:
- prefix: ''
  shellQuote: false
  position: 0
  valueFrom: |-
    ${
       
       function find_chromosome(file){
            var chr_array = []
            var chrom_num = file.split("/").pop()
            chrom_num = chrom_num.substr(0,chrom_num.lastIndexOf(".")).split('_').slice(0,-1).join('_')
            if(isNumeric(chrom_num.charAt(chrom_num.length-2)))
            {
                chr_array.push(chrom_num.substr(chrom_num.length - 2))
            }
            else
            {
                chr_array.push(chrom_num.substr(chrom_num.length - 1))
            }
            return chr_array.toString()
        }
       
       function isNumeric(s) {
            return !isNaN(s - parseFloat(s));
        }
       
       var chr = inputs.gds_file.path.split('chr')[1].split('.')[0];

       
       if(inputs.check_gds == 'Yes'){
        return "Rscript /usr/local/analysis_pipeline/R/check_gds.R check_gds.config " +"--chromosome " + chr}
        else{
             return 'echo Check GDS step skipped.'
        }
    }
- prefix: ''
  shellQuote: false
  position: 100
  valueFrom: ${return " >> job.out.log"}
requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  ramMin: 30000
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.8.1
- class: InitialWorkDirRequirement
  listing:
  - entryname: check_gds.config
    entry: |-
      ${  
          var config = "";
          var vcf_array = [].concat(inputs.vcf_file);
          var vcf_first_part = vcf_array[0].path.split('chr')[0];
          var vcf_second_part = vcf_array[0].path.split('chr')[1].split('.');
          vcf_second_part.shift();
          config += "vcf_file \"" + vcf_first_part + 'chr .' + vcf_second_part.join('.') + "\"\n";
          var gds_first_part = inputs.gds_file.path.split('chr')[0];
          var gds_second_part = inputs.gds_file.path.split('chr')[1].split('.');
          gds_second_part.shift();
          config += "gds_file \"" + gds_first_part + 'chr .' + gds_second_part.join('.') + "\"\n";
          if(inputs.sample_file)
              config += "sample_file \"" + inputs.sample_file.path + "\"\n"
          return config
      }
         
    writable: false
- class: InlineJavascriptRequirement
hints:
- class: sbg:SaveLogs
  value: job.out.log
sbg:projectName: GENESIS toolkit - DEMO
sbg:revisionsInfo:
- sbg:revision: 0
  sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1570633738
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/check_gds/0
- sbg:revision: 1
  sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1573150398
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/check_gds/1
- sbg:revision: 2
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1591619529
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/check_gds/2
- sbg:revision: 3
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1593594792
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/check_gds/3
- sbg:revision: 4
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1593603597
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/check_gds/4
- sbg:revision: 5
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1593606272
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/check_gds/5
- sbg:revision: 6
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1593608329
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/check_gds/6
- sbg:revision: 7
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1593611882
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/check_gds/7
- sbg:revision: 8
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1593621224
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/check_gds/8
- sbg:revision: 9
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602060540
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/check_gds/9
- sbg:revision: 10
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602062431
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/check_gds/10
- sbg:revision: 11
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602064977
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/check_gds/11
- sbg:revision: 12
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602071276
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/check_gds/12
sbg:image_url:
sbg:appVersion:
- v1.1
sbg:id: boris_majic/genesis-toolkit-demo/check_gds/12
sbg:revision: 12
sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/check_gds/12
sbg:modifiedOn: 1602071276
sbg:modifiedBy: dajana_panovic
sbg:createdOn: 1570633738
sbg:createdBy: boris_majic
sbg:project: boris_majic/genesis-toolkit-demo
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:contributors:
- boris_majic
- dajana_panovic
sbg:latestRevision: 12
sbg:publisher: sbg
sbg:content_hash: a858c95ade17914a74f300bf521d8ce6fbb7a5978eb658abf2212dc1fd9e52b52
sbg:copyOf: boris_majic/genesis-toolkit-dev/check_gds/12
