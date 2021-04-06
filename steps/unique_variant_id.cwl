class: CommandLineTool
cwlVersion: v1.1
$namespaces:
  sbg: https://sevenbridges.com
id: boris_majic/genesis-toolkit-demo/unique-variant-id/17
baseCommand: []
inputs:
- id: gds_file
  type: File[]
  label: GDS file
  doc: List of GDS files produced by VCF2GDS tool.
  sbg:fileTypes: GDS
outputs:
- id: unique_variant_id_gds_per_chr
  doc: Corrected GDS files per chromosome.
  label: Unique variant ID corrected GDS files per chromosome
  type: File[]?
  outputBinding:
    glob: '*chr*'
    outputEval: $(inheritMetadata(self, inputs.gds_file))
  sbg:fileTypes: GDS
- id: config
  doc: Config file for running the R script.
  label: Config file
  type: File?
  outputBinding:
    glob: '*.config'
  sbg:fileTypes: CONFIG
label: unique_variant_id
arguments:
- prefix: ''
  shellQuote: false
  position: 5
  valueFrom: |-
    ${
        var cmd_line = "cp ";
        for (var i=0; i<inputs.gds_file.length; i++)
            cmd_line += inputs.gds_file[i].path + " "
        cmd_line += ". && "
        if(inputs.merged_gds_file)
        {
            cmd_line += "cp " + inputs.merged_gds_file.path + " . && "
        }
        return cmd_line
    }
- prefix: ''
  shellQuote: false
  position: 10
  valueFrom: |-
    ${
        return " Rscript /usr/local/analysis_pipeline/R/unique_variant_ids.R unique_variant_ids.config"
    }
- prefix: ''
  shellQuote: false
  position: 100
  valueFrom: |-
    ${
        return ' >> job.out.log'
    }
requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.8.1
- class: InitialWorkDirRequirement
  listing:
  - entryname: unique_variant_ids.config
    entry: |
      ${
          function isNumeric(s) {
              return !isNaN(s - parseFloat(s));
          }
          
          function compareNatural(a,b){
              return a.localeCompare(b, 'en', {numeric: true, ignorePunctuation: true})
          }
          
          function find_chromosome(file){
              var chr_array = [];
              var chrom_num = file.split("/").pop();
              chrom_num = chrom_num.split("chr")[1];
              
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
          var chr = find_chromosome(inputs.gds_file[0].path);
          var gds = inputs.gds_file[0].path.split('/').pop();
          
          
          
          var chr_array = [];
          for (var i = 0; i < inputs.gds_file.length; i++) 
          {
              var chrom_num = inputs.gds_file[i].path.split("/").pop();
              chrom_num = chrom_num.split("chr")[1];
              
              if(isNumeric(chrom_num.charAt(1)))
              {
                  chr_array.push(chrom_num.substr(0,2))
              }
              else
              {
                  chr_array.push(chrom_num.substr(0,1))
              }
          }
          
          
          
          chr_array = chr_array.sort(compareNatural);
          var chrs = "";
          for (var i = 0; i < chr_array.length; i++) 
          {
              chrs += chr_array[i] + " "
          }
          
          
          var ind_X = chrs.includes("X")
          var ind_Y = chrs.includes("Y")
          var ind_M = chrs.includes("M")
          
          var chr_array = chrs.split(" ")
          var chr_order = [];
          var chr_result = ""
          
          for(i=0; i<chr_array.length; i++){
              
          if(!isNaN(chr_array[i]) && chr_array[i]!= "") {chr_order.push(parseInt(chr_array[i]))}    
              
              
          }
          
          
          chr_order = chr_order.sort(function(a, b){return a-b})
          for(i=0; i<chr_order.length; i++){
              
              chr_result += chr_order[i].toString() + " "
          }
          
          if(ind_X) chr_result += "X "
          if(ind_Y) chr_result += "Y "
          if(ind_M) chr_result += "M "
          
          chrs = chr_result

          
          
          var return_arguments = [];
          return_arguments.push('gds_file "' + gds.split("chr")[0] + "chr "+gds.split("chr"+chr)[1] +'"');
          return_arguments.push('chromosomes "' + chrs + '"')
          
          return return_arguments.join('\n') + "\n"
      }
    writable: false
- class: InlineJavascriptRequirement
  expressionLib:
  - |2-

    var setMetadata = function(file, metadata) {
        if (!('metadata' in file))
            file['metadata'] = metadata;
        else {
            for (var key in metadata) {
                file['metadata'][key] = metadata[key];
            }
        }
        return file
    };

    var inheritMetadata = function(o1, o2) {
        var commonMetadata = {};
        if (!Array.isArray(o2)) {
            o2 = [o2]
        }
        for (var i = 0; i < o2.length; i++) {
            var example = o2[i]['metadata'];
            for (var key in example) {
                if (i == 0)
                    commonMetadata[key] = example[key];
                else {
                    if (!(commonMetadata[key] == example[key])) {
                        delete commonMetadata[key]
                    }
                }
            }
        }
        if (!Array.isArray(o1)) {
            o1 = setMetadata(o1, commonMetadata)
        } else {
            for (var i = 0; i < o1.length; i++) {
                o1[i] = setMetadata(o1[i], commonMetadata)
            }
        }
        return o1;
    };
hints:
- class: sbg:SaveLogs
  value: job.out.log
sbg:revisionsInfo:
- sbg:revision: 0
  sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1570633744
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/unique-variant-id/0
- sbg:revision: 1
  sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1573150407
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/unique-variant-id/2
- sbg:revision: 2
  sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1573217934
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/unique-variant-id/3
- sbg:revision: 3
  sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1580990670
  sbg:revisionNotes: Copy of boris_majic/genesis-toolkit-dev/unique-variant-id/4
- sbg:revision: 4
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1580998414
  sbg:revisionNotes: Sort updated/Natural sort
- sbg:revision: 5
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1581435418
  sbg:revisionNotes: gds file name correction
- sbg:revision: 6
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1581499425
  sbg:revisionNotes: GDS filename correction
- sbg:revision: 7
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1582046901
  sbg:revisionNotes: GDS filename correction 2
- sbg:revision: 8
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1582278934
  sbg:revisionNotes: GDS filename
- sbg:revision: 9
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1582280832
  sbg:revisionNotes: GDS filename correction
- sbg:revision: 10
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1593594910
  sbg:revisionNotes: 'New Docker image: 2.8.0'
- sbg:revision: 11
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602060919
  sbg:revisionNotes: Docker 2.8.1 and SaveLogs hint
- sbg:revision: 12
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602062462
  sbg:revisionNotes: SaveLogs hint
- sbg:revision: 13
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602064958
  sbg:revisionNotes: SaveLogs hint
- sbg:revision: 14
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1603716594
  sbg:revisionNotes: Config cleaning
- sbg:revision: 15
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1604486153
  sbg:revisionNotes: cwltool
- sbg:revision: 16
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1604486327
  sbg:revisionNotes: cwltool
- sbg:revision: 17
  sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1606724218
  sbg:revisionNotes: ''
sbg:projectName: GENESIS toolkit - DEMO
sbg:image_url:
sbg:appVersion:
- v1.1
sbg:id: boris_majic/genesis-toolkit-demo/unique-variant-id/17
sbg:revision: 17
sbg:revisionNotes: ''
sbg:modifiedOn: 1606724218
sbg:modifiedBy: dajana_panovic
sbg:createdOn: 1570633744
sbg:createdBy: boris_majic
sbg:project: boris_majic/genesis-toolkit-demo
sbg:sbgMaintained: false
sbg:validationErrors: []
sbg:contributors:
- boris_majic
- dajana_panovic
sbg:latestRevision: 17
sbg:publisher: sbg
sbg:content_hash: a656fb5a26922b1d56dfe360e1ab2f231a1c4d2f8bb52fd756072d794ed63602a
