extends Node

func get_random_point_near_line(line_point, director_vector):
	var ortogonal_director_vector = Vector2(-director_vector.y, director_vector.x)
	var lambda_value_for_line_point = get_lambda_for_line_point(line_point, line_point, director_vector)
	lambda_value_for_line_point += 2
	var ortogonal_line_point = get_point_in_line(lambda_value_for_line_point, line_point, director_vector)
	var lambda_value_for_ortogonal_line = get_lambda_for_line_point(ortogonal_line_point, ortogonal_line_point, ortogonal_director_vector)
	var lambda_variance = randf_range(-3, 3)
	lambda_value_for_ortogonal_line += lambda_variance
	return get_point_in_line(lambda_value_for_ortogonal_line, ortogonal_line_point, ortogonal_director_vector)

func get_lambda_for_line_point(point, line_point, director_vector):
	var lambda_value = (point.x - line_point.x) / director_vector.x
	return lambda_value

func get_point_in_line(lambda, line_point, director_vector):
	var point_x = line_point.x + lambda * director_vector.x
	var point_y = line_point.y + lambda * director_vector.y
	return Vector2(point_x, point_y)
