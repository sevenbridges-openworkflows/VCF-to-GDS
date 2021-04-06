class: CommandLineTool
cwlVersion: v1.1
$namespaces:
  sbg: https://sevenbridges.com
id: boris_majic/genesis-toolkit-demo/vcf2gds/30
baseCommand: []
inputs:
- sbg:category: Input Files
  id: vcf_file
  type: File
  label: Variants Files
  doc: Input Variants Files.
  sbg:fileTypes: VCF, VCF.GZ, BCF
- id: gds_file_name
  type: string?
  label: GDS File
  doc: Output GDS file.
- sbg:category: Input options
  sbg:toolDefaultValue: '4'
  id: memory_gb
  type: float?
  label: Memory GB
  doc: Memory in GB for each job.
- sbg:category: Input Options
  sbg:toolDefaultValue: '1'
  id: cpu
  type: int?
  label: Cpu
  doc: Number of CPUs for each tool job.
- sbg:category: General
  sbg:toolDefaultValue: GT
  id: format
  type: string[]?
  label: Format
  doc: VCF Format fields to keep in GDS file.
outputs:
- id: gds_output
  doc: GDS Output File.
  label: GDS Output File
  type: File?
  outputBinding:
    glob: '*.gds'
  sbg:fileTypes: GDS
- id: config_file
  type: File?
  outputBinding:
    glob: '*.config'
  sbg:fileTypes: CONFIG
label: vcf2gds
arguments:
- prefix: ''
  shellQuote: false
  position: 5
  valueFrom: |-
    ${
        return "Rscript /usr/local/analysis_pipeline/R/vcf2gds.R vcf2gds.config"
    }
- prefix: ''
  shellQuote: false
  position: 1
  valueFrom: |-
    ${
        if (inputs.cpu)
            return 'export NSLOTS=' + inputs.cpu + ' &&'
        else
            return ''
    }
- prefix: ''
  shellQuote: false
  position: 100
  valueFrom: |-
    ${
        return " >> job.out.log"
    }
requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  ramMin: |-
    ${
        if(inputs.memory_gb)
            return parseFloat(inputs.memory_gb * 1024)
        else
            return 4*1024.0
    }
  coresMin: |-
    ${ if(inputs.cpu)
            return inputs.cpu 
        else 
            return 1
    }
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.8.1
- class: InitialWorkDirRequirement
  listing:
  - entryname: vcf2gds.config
    entry: |-
      ${  
          function isNumeric(s) {
              return !isNaN(s - parseFloat(s));
          }
          function find_chromosome(file){
              var chr_array = [];
              var chrom_num = file.split("chr")[1];
              
              if(isNumeric(chrom_num.charAt(1)))
              {
                  chr_array.push(chrom_num.substr(0,2))
              }
              else
              {
                  chr_array.push(chrom_num.substr(0,1))
              }
              return chr_array.toString()
          }
          var config = "";
          config += "vcf_file \"" + inputs.vcf_file.path + "\"\n"
          if(inputs.format)
          {
              config += "format \"" + inputs.format.join(' ') + "\"\n"
          }
          else
          {
              config += "format \"GT\"\n"
          }
          if(inputs.gds_file_name)
              config += "gds_file \"" + inputs.gds_file_name + "\"\n"
          else
          {    
              
              if (inputs.vcf_file.basename.indexOf('.bcf') == -1){
              
               var chromosome = "chr" + find_chromosome(inputs.vcf_file.path);
               config += "gds_file \"" + inputs.vcf_file.path.split('/').pop().split(chromosome)[0] + chromosome + inputs.vcf_file.path.split('/').pop().split(chromosome)[1].split('.vcf')[0] +".gds\"";
              } else{
                  
                   var chromosome = "chr" + find_chromosome(inputs.vcf_file.path);
                   config += "gds_file \"" + inputs.vcf_file.path.split('/').pop().split(chromosome)[0] + chromosome + inputs.vcf_file.path.split('/').pop().split(chromosome)[1].split('.bcf')[0] +".gds\"";    
                  
                     }
              
              
          }
          return config
      }
         
    writable: false
- class: InlineJavascriptRequirement
hints:
- class: sbg:SaveLogs
  value: job.out.log
sbg:revisionsInfo:
- sbg:revision: 0
  sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1570633741
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/vcf2gds/0
- sbg:revision: 1
  sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1573150402
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/vcf2gds/2
- sbg:revision: 2
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1581435376
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/vcf2gds/3
- sbg:revision: 3
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1583254627
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/vcf2gds/4
- sbg:revision: 4
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1583255376
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/vcf2gds/5
- sbg:revision: 5
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1583256167
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/vcf2gds/6
- sbg:revision: 6
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1590669591
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/vcf2gds/7
- sbg:revision: 7
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1591109407
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/vcf2gds/8
- sbg:revision: 8
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1593594797
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/vcf2gds/9
- sbg:revision: 9
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1593621255
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/vcf2gds/10
- sbg:revision: 10
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1593676553
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/vcf2gds/11
- sbg:revision: 11
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602060519
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/vcf2gds/12
- sbg:revision: 12
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602062439
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/vcf2gds/13
- sbg:revision: 13
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602064974
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/vcf2gds/14
- sbg:revision: 14
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602071280
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/vcf2gds/15
- sbg:revision: 15
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602073465
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/vcf2gds/16
- sbg:revision: 16
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1604408407
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/vcf2gds/17
- sbg:revision: 17
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1604409014
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/vcf2gds/18
- sbg:revision: 18
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1604409234
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/vcf2gds/19
- sbg:revision: 19
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1604409876
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/vcf2gds/20
- sbg:revision: 20
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1604410004
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/vcf2gds/21
- sbg:revision: 21
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1604410367
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/vcf2gds/22
- sbg:revision: 22
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1604410483
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/vcf2gds/23
- sbg:revision: 23
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1604410784
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/vcf2gds/24
- sbg:revision: 24
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1604414507
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/vcf2gds/25
- sbg:revision: 25
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1604421371
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/vcf2gds/26
- sbg:revision: 26
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1604422469
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/vcf2gds/27
- sbg:revision: 27
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1604422689
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/vcf2gds/29
- sbg:revision: 28
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1604424705
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/vcf2gds/30
- sbg:revision: 29
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1604485485
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/vcf2gds/31
- sbg:revision: 30
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1606724144
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/vcf2gds/32
sbg:projectName: GENESIS toolkit - DEMO
sbg:image_url:
sbg:appVersion:
- v1.1
sbg:id: boris_majic/genesis-toolkit-demo/vcf2gds/30
sbg:revision: 30
sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/vcf2gds/32
sbg:modifiedOn: 1606724144
sbg:modifiedBy: dajana_panovic
sbg:createdOn: 1570633741
sbg:createdBy: boris_majic
sbg:project: boris_majic/genesis-toolkit-demo
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:contributors:
- boris_majic
- dajana_panovic
sbg:latestRevision: 30
sbg:publisher: sbg
sbg:content_hash: a277b525309d1bcdb65bb97d04807ce4a03c39a45df5c58e76fc70de56b91eaa8
sbg:copyOf: boris_majic/genesis-toolkit-dev/vcf2gds/32
