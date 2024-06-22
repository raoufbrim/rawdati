from sqlalchemy.orm import Session ,joinedload 
import models, schemas
from passlib.context import CryptContext
from sqlalchemy.exc import IntegrityError
from sqlalchemy.ext.declarative import declarative_base
import asyncio


Base = declarative_base()
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def get_user_by_email(db: Session, email: str):
    return db.query(models.User).filter(models.User.email == email).first()

def create_user(db: Session, user: schemas.UserCreate):

    db_user = models.User(
        first_name=user.first_name,
        last_name=user.last_name,
        username=user.username,
        email=user.email,
        phone_number=user.phone_number,
        password=user.password,
        profile_picture=user.profile_picture,
        role=user.role
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user


def update_user(db: Session, user_id: int, user_update: schemas.UserUpdate):
    user = db.query(models.User).filter(models.User.id == user_id).first()
    if user is None:
        return None
    for key, value in user_update.dict(exclude_unset=True).items():
        setattr(user, key, value)
    db.commit()
    db.refresh(user)
    return user

def delete_user(db: Session, user_id: int):
    user = db.query(models.User).filter(models.User.id == user_id).first()
    if user is None:
        return None
    
    # Check if the user is a teacher and has classes
    if user.role == models.UserRole.teacher:
        # Optionally, handle class reassignment or deletion if necessary
        db.query(models.Class).filter(models.Class.teacher_id == user_id).delete()
    
    db.delete(user)
    db.commit()
    return user







def get_teachers(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.User).filter(models.User.role == models.UserRole.teacher).offset(skip).limit(limit).all()


def create_class(db: Session, cls: schemas.ClassCreate):
    db_class = models.Class(**cls.dict())
    db.add(db_class)
    try:
        db.commit()
        db.refresh(db_class)
        return db_class
    except IntegrityError:
        db.rollback()
        raise ValueError("Class name already exists. Please choose a different name.")

# def get_classes(db: Session, skip: int = 0, limit: int = 100):
#     return db.query(models.Class).offset(skip).limit(limit).all()

def get_classes(db: Session, skip: int = 0, limit: int = 100):
    db_classes = db.query(models.Class).offset(skip).limit(limit).all()
    classes_with_students = []

    for db_class in db_classes:
        db_students = db.query(models.Student).filter(models.Student.class_id == db_class.id).all()
        student_info = [
            {
                "full_name": student.full_name,
                "date_of_birth": student.date_of_birth,
                "profile_picture": student.profile_picture
            }
            for student in db_students
        ]
        class_info = {
            "id": db_class.id,
            "name": db_class.name,
            "students": student_info,
            "student_count": len(student_info)
        }
        classes_with_students.append(class_info)
    
    return classes_with_students


def get_class_details_by_name(db: Session, class_name: str):
    db_class = db.query(models.Class).filter(models.Class.name == class_name).first()
    if not db_class:
        return None

    db_teacher = db.query(models.User).filter(models.User.id == db_class.teacher_id).first()
    db_students = db.query(models.Student).filter(models.Student.class_id == db_class.id).all()
    
    teacher_info = {
        "first_name": db_teacher.first_name,
        "last_name": db_teacher.last_name,
        "email": db_teacher.email,
        "profile_picture": db_teacher.profile_picture
    }
    student_info = [
        {
            "full_name": student.full_name,
            "date_of_birth": student.date_of_birth,
            "profile_picture": student.profile_picture
        }
        for student in db_students
    ]
    
    return {
        "id": db_class.id,
        "name": db_class.name,
        "teacher": teacher_info,
        "students": student_info,
        "student_count": len(student_info)
    }




def get_student_by_name(db: Session, full_name: str):
    return db.query(models.Student).filter(models.Student.full_name == full_name).first()

def create_student(db: Session, student: schemas.StudentCreate):
    db_student = models.Student(
        full_name=student.full_name,
        date_of_birth=student.date_of_birth,
        school_year=student.school_year,
        parent_phone_number=student.parent_phone_number,
        profile_picture=student.profile_picture,
        class_id=student.class_id
    )
    db.add(db_student)
    db.commit()
    db.refresh(db_student)
    return db_student


def get_student_by_name(db: Session, full_name: str):
    return db.query(models.Student).filter(models.Student.full_name == full_name).first()

def get_students_by_class_id(db: Session, class_id: int):
    return db.query(models.Student).filter(models.Student.class_id == class_id).all()

def get_students(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.Student).offset(skip).limit(limit).all()

def update_student(db: Session, student_id: int, student_update: schemas.StudentUpdate):
    db_student = db.query(models.Student).filter(models.Student.id == student_id).first()
    if not db_student:
        return None
    for key, value in student_update.dict(exclude_unset=True).items():
        setattr(db_student, key, value)
    db.commit()
    db.refresh(db_student)
    return db_student

def delete_student(db: Session, student_id: int):
    student = db.query(models.Student).filter(models.Student.id == student_id).first()
    if student is None:
        return None
    db.delete(student)
    db.commit()
    return student


def delete_class(db: Session, class_id: int):
    db_class = db.query(models.Class).options(joinedload(models.Class.teacher)).filter(models.Class.id == class_id).first()
    if not db_class:
        return None
    
    # Suppression des étudiants liés à cette classe
    db.query(models.Student).filter(models.Student.class_id == class_id).delete()
    
    # Charger l'enseignant avant de supprimer la classe
    teacher = db_class.teacher
    
    db.delete(db_class)
    db.commit()
    return db_class

def create_or_update_prediction_result(db: Session, prediction: schemas.PredictionCreate):
    # Vérifiez si une prédiction existe déjà pour cet étudiant
    db_prediction = db.query(models.PredictionResult).filter(
        models.PredictionResult.student_full_name == prediction.student_full_name
    ).first()
    
    if db_prediction:
        # Mise à jour de la prédiction existante
        db_prediction.result = prediction.result
        db_prediction.disease = prediction.disease
        db_prediction.recommendation = prediction.recommendation
        db.commit()
        db.refresh(db_prediction)
        return db_prediction
    else:
        # Création d'une nouvelle prédiction si aucune n'existe
        db_prediction = models.PredictionResult(**prediction.dict())
        db.add(db_prediction)
        db.commit()
        db.refresh(db_prediction)
        return db_prediction


def get_students_with_detected_trouble(db: Session):
    return db.query(models.PredictionResult).filter(models.PredictionResult.result != "non malade").all()




def create_notification(db: Session, message: str):
    notification = models.Notification(message=message , is_read=False)
    db.add(notification)
    db.commit()
    db.refresh(notification)


    from main import manager
    asyncio.create_task(manager.broadcast(message))
    return notification

def get_unread_notifications(db: Session):
    return db.query(models.Notification).filter(models.Notification.is_read == False).all()

def mark_notifications_as_read_and_delete(db: Session):
    notifications = db.query(models.Notification).filter(models.Notification.is_read == False).all()
    for notification in notifications:
        notification.is_read = True
    db.commit()
    
    # Suppression des notifications lues
    db.query(models.Notification).filter(models.Notification.is_read == True).delete()
    db.commit()
    return notifications
