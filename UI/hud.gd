extends Control

var score := 0

func increment_score(score_amount):
	score += score_amount
	$ScoreLabel.text = str(score)
