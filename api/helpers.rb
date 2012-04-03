def validate_throw(value, mult)
	if (value >= 1 && value <= 20) && (mult >= 1 && mult <= 3) # Normal area
		return true
	end
	if value == 25 && (mult >= 1 && mult <= 2) # Bulls eye/ring
		return true
	end
	return false
end
