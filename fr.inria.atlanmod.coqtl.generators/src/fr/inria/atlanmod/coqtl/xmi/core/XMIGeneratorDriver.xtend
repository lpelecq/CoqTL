package fr.inria.atlanmod.coqtl.xmi.core

import fr.inria.atlanmod.coqtl.util.EMFUtil
import fr.inria.atlanmod.coqtl.util.URIUtil
import org.eclipse.emf.common.util.URI

class XMIGeneratorDriver {
	
	def static doGeneration(URI mm_path, URI model, URI output_uri){
		
		val resource_set = EMFUtil.loadEcore(mm_path)
		val resource = resource_set.getResource(model, true)
		
		var content = ""
		val compiler = new XMI2Coq
		content += compiler.mapEObjects(resource.contents)	
		URIUtil.write(output_uri, content)
	}
	
	def static void main(String[] args) {
		if(args.length < 3){
			println("Input of XMI2Coq:");
			println("1. MetaModel relative path, e.g. resources/TT2BDD/TT.ecore");
			println("2. Model relative path, e.g. resources/TT2BDD/xor.ttmodel");
			println("3. Output path, e.g. resources/TT2BDD/xorTT.v");
			System.exit(0)
		}

		val m_path = args.get(0)
		val mm_path = args.get(1)
		val m_uri = URI.createFileURI(m_path);
		val mm_uri = URI.createFileURI(mm_path)
		val output_path = args.get(2)
		val output_uri = URI.createFileURI(output_path);
		
		
        doGeneration(mm_uri, m_uri, output_uri)

    }
    

}
