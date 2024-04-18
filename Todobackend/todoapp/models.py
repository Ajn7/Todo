from django.db import models
from django.contrib.auth.models import User

# Create your models here.
class Project(models.Model):
    user = models.ForeignKey(User,on_delete=models.CASCADE) #user means user_id
    project_id=models.IntegerField(primary_key=True)
    title=models.CharField(max_length=300)
    created_at=models.DateTimeField(auto_now_add=True)
    def __str__(self):
        return self.title
    
class Todo(models.Model):
    project_ref_id=models.ForeignKey(Project,on_delete=models.CASCADE)
    title=models.CharField(max_length=300)
    description=models.CharField(max_length=300)
    status=models.CharField(max_length=15)
    created_at=models.DateTimeField(auto_now_add=True)
    updated_at=models.DateTimeField()
    def __str__(self):
        return self.description
    
    
