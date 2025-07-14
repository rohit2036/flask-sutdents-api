from flask import Blueprint, request, jsonify
from .models import Student
from . import db
import logging


api_v1 = Blueprint('api_v1', __name__, url_prefix="/api/v1")


@api_v1.route('/students', methods=['POST'])
def create_student():
    data = request.get_json()
    student = Student(name=data['name'], age=data['age'], grade=data['grade'])
    db.session.add(student)
    db.session.commit()
    logging.info("Student created with ID: %s", student.id)
    return jsonify({"id": student.id}), 201


@api_v1.route('/students', methods=['GET'])
def get_students():
    students = Student.query.all()
    return jsonify([
        {
            "id": s.id,
            "name": s.name,
            "age": s.age,
            "grade": s.grade
        } for s in students
    ])


@api_v1.route('/students/<int:id>', methods=['GET'])
def get_student(id):
    student = Student.query.get(id)
    if not student:
        return jsonify({"error": "Not found"}), 404
    return jsonify({
        "id": student.id,
        "name": student.name,
        "age": student.age,
        "grade": student.grade
    })


@api_v1.route('/students/<int:id>', methods=['PUT'])
def update_student(id):
    student = Student.query.get(id)
    if not student:
        return jsonify({"error": "Not found"}), 404
    data = request.get_json()
    student.name = data.get('name', student.name)
    student.age = data.get('age', student.age)
    student.grade = data.get('grade', student.grade)
    db.session.commit()
    logging.info("Student with ID %s updated", id)
    return jsonify({"message": "Updated successfully"})


@api_v1.route('/students/<int:id>', methods=['DELETE'])
def delete_student(id):
    student = Student.query.get(id)
    if not student:
        return jsonify({"error": "Not found"}), 404
    db.session.delete(student)
    db.session.commit()
    logging.info("Student with ID %s deleted", id)
    return jsonify({"message": "Deleted successfully"})


@api_v1.route("/healthcheck")
def healthcheck():
    return {"status": "ok"}, 200
