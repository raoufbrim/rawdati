from sqlalchemy import Column, Integer, String, ForeignKey, Enum, Date, Text, UniqueConstraint, Boolean, TIMESTAMP
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from database import Base
import enum

class UserRole(enum.Enum):
    admin = "admin"
    teacher = "teacher"

class User(Base):
    __tablename__ = 'User'
    id = Column(Integer, primary_key=True, index=True)
    first_name = Column(String(100), index=True)
    last_name = Column(String(100), index=True)
    username = Column(String(100), unique=True, index=True)
    email = Column(String(100), unique=True, index=True)
    phone_number = Column(String(15))
    password = Column(String(100))
    profile_picture = Column(String(255))
    role = Column(Enum(UserRole))
    classes = relationship("Class", back_populates="teacher", cascade="all, delete-orphan")

class Class(Base):
    __tablename__ = 'Class'
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), index=True)
    teacher_id = Column(Integer, ForeignKey('User.id'))
    teacher = relationship("User", back_populates="classes")

    __table_args__ = (UniqueConstraint('name', name='_class_name_uc'),)

class Student(Base):
    __tablename__ = 'Student'
    id = Column(Integer, primary_key=True, index=True)
    full_name = Column(String(100), index=True)
    date_of_birth = Column(Date)
    school_year = Column(String(10))
    parent_phone_number = Column(String(15))
    profile_picture = Column(String, nullable=True) 
    class_id = Column(Integer, ForeignKey('Class.id'))

class PredictionResult(Base):
    __tablename__ = 'PredictionResult'
    id = Column(Integer, primary_key=True, index=True)
    student_full_name = Column(String(255))
    result = Column(String(255))
    disease = Column(String(255))
    recommendation = Column(Text)



class Notification(Base):
    __tablename__ = 'notification'
    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    message = Column(Text, nullable=False)
    is_read = Column(Boolean, default=False)
    created_at = Column(TIMESTAMP, server_default=func.now())


