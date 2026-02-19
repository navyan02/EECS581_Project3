'''
File Name: dot.gd
Created: 2/10/2026
Last Updated: 2/15/2026
Description: Starts all of the stars off unconnected from one another.
'''

extends Area2D

@export var neighbors = []
var connected := false
