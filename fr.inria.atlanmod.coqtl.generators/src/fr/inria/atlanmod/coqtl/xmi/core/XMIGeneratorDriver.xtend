package fr.inria.atlanmod.coqtl.xmi.core

import fr.inria.atlanmod.coqtl.util.EMFUtil
import fr.inria.atlanmod.coqtl.util.URIUtil
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl

class XMIGeneratorDriver {
		
	/** 
	 * Setup EMF factories, precondition to load ecore resources into memory.
	 * */
	def static doEMFSetup() {
		// register resource processors
		Resource.Factory.Registry.INSTANCE.extensionToFactoryMap.put("ttmodel", new XMIResourceFactoryImpl());
		Resource.Factory.Registry.INSTANCE.extensionToFactoryMap.put("bddmodel", new XMIResourceFactoryImpl());
	}

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
			println("1. Model relative path, e.g. resources/TT2BDD/xor.ttmodel");
			println("2. MetaModel relative path, e.g. resources/TT2BDD/TT.ecore");
			println("3. Output path, e.g. resources/TT2BDD/xorTT.v");
			System.exit(0)
		}

		val m_path = args.get(0)
		val mm_path = args.get(1)
		val m_uri = URI.createFileURI(m_path);
		val mm_uri = URI.createFileURI(mm_path)
		val output_path = args.get(2)
		val output_uri = URI.createFileURI(output_path);
		
		doEMFSetup
        doGeneration(mm_uri, m_uri, output_uri)

    }
    

}
