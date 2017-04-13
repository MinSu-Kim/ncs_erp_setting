package kr.or.dgit.ncs.jdbc;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class LoadProperties {
	
	private Properties prop;
	private String resource;
	
	public LoadProperties(String resource) {
		this.resource = resource;
		prop = new Properties();
		configurationAsProperties();
	}
	
	private void configurationAsProperties() {
		ClassLoader contextClassLoader = Thread.currentThread().getContextClassLoader();
		
		try (InputStream inputStream = contextClassLoader.getResourceAsStream(resource)){
			prop.load(inputStream);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public Properties getConfProp() {
		return prop;
	}

}
