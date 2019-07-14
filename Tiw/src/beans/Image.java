package beans;

import java.io.File;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

public class Image {
	private String absolutePath;
	private String name;
	private BigDecimal positiveRatings;
	private BigDecimal negativeRatings;
	private Map<String, String> annotations;
	
	public Image() {
		annotations = new HashMap<String, String>();
	}
	
	public String getAbsolutePath() {
		return absolutePath;
	}
	
	public void setAbsolutePath(String absolutePath) {
		this.absolutePath = absolutePath;
		
		int lastSeparatorIndex = this.absolutePath.lastIndexOf(File.separator);
		this.name = this.absolutePath.substring(lastSeparatorIndex+1);
	}
	
	public String getName() {
		return name;
	}
	
	public BigDecimal getPositiveRatings() {
		return positiveRatings;
	}
	
	public void setPositiveRatings(BigDecimal positiveRatings) {
		this.positiveRatings = positiveRatings;
	}
	
	public BigDecimal getNegativeRatings() {
		return negativeRatings;
	}
	
	public void setNegativeRatings(BigDecimal negativeRatings) {
		this.negativeRatings = negativeRatings;
	}
	
	public Map<String, String> getAnnotations() {
		return annotations;
	}
	
	public void addAnnotation(String worker, String annotation) {
		annotations.put(worker, annotation);
	}
}
