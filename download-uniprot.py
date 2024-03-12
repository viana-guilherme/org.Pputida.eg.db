#!/usr/bin/python3

import xml.etree.ElementTree as ET
from ftplib import FTP
import os
import requests
import json
import gzip
import csv

# 0) Setup

# creates the local directory where files will be downloaded
os.makedirs("resources", exist_ok=True)

# prepares the list in which results will be saved (for the output file)
gene_info_list = [["GID", "GO", "EVIDENCE"]] # these will basically be our column names in the output

# 1) downloading the current Uniprot release of the annotated proteome

# creating variables that hold the file paths in the server
remote_file = "UP000000556_160488.xml.gz"
local_file = f"resources/{remote_file}"

# starting the ftp connection
uniprot = FTP('ftp.uniprot.org')
uniprot.login()

# changing the directory to where the reference proteome is located 
directory = "pub/databases/uniprot/current_release/knowledgebase/reference_proteomes/Bacteria/UP000000556"
uniprot.cwd(directory)

#sets up the download
with open(local_file, "wb") as f:
	uniprot.retrbinary(f"RETR {remote_file}", f.write)

# closing the connection
uniprot.quit()

# reads the compressed data of the newly downloaded file
with gzip.open(local_file, 'rb') as f_in: 
	file_content = f_in.read()
   
# write out the new file
with open(f"{local_file[:-3]}", "wb") as f_out:
	f_out.write(file_content)

# 2) Processing the file to retrieve GO information

# define the namespace prefixes (for traversing the XML tree):
namespaces = {
    'uniprot': 'http://uniprot.org/uniprot',
    'xsi': 'http://www.w3.org/2001/XMLSchema-instance'
}

# open the connection to the XML file
tree = ET.parse(f"{local_file[:-3]}")

# get the root element
root = tree.getroot()

# Find all <entry> elements within the 'uniprot' namespace
entry_elements = root.findall('uniprot:entry', namespaces=namespaces)

# Iterate through the <entry> elements
for entry_element in entry_elements:
	
	# find all <gene> elements
	gene_elements = entry_element.findall('uniprot:gene/uniprot:name[@type="ordered locus"]', namespaces=namespaces)
	for gene in gene_elements:
		
		# retrieve the locus tag
		gene_value = gene.text
			
		# Find all GO terms associated with a given <gene>
		go_elements = entry_element.findall('uniprot:dbReference[@type="GO"]', namespaces=namespaces)
		
		# as we can have multiple GO terms for each gene, we iterate to find the evidence type for each
		for go in go_elements:
			go_value = go.attrib['id']
			
			properties = go.findall('uniprot:property[@type="evidence"]', namespaces = namespaces)
			
			for prop in properties:
				prop_value = prop.attrib['value']
				
				# finally, update the gene information list
				gene_info_list.append([gene_value, go_value, prop_value])

# save the parsed data in a TSV file
with open('resources/fGO.tsv', 'w', newline='') as file:
	
	writer = csv.writer(file, delimiter="\t")
	
	for newEntry in gene_info_list:
		print(newEntry)
		writer.writerow(newEntry)

