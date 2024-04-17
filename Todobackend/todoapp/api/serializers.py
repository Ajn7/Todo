from rest_framework import serializers
from  todoapp.models import Project,Todo

class ProjectInformationSerializer(serializers.ModelSerializer):
   
    class Meta:
        model=Project
        fields = "__all__"
        
class TodoInformationSerializer(serializers.ModelSerializer):
   
    class Meta:
        model=Todo
        fields = "__all__"
        
class ProjectSerializer(serializers.ModelSerializer):
    class Meta:
        model = Project
        fields = ['title']  # Include any other fields you want from the Project model

        
# class TodoInformationListSerializer(serializers.ModelSerializer):
#     project = ProjectInformationSerializer()
#     class Meta:
#         model = Todo
#         fields = ['id', 'project_ref_id', 'description', 'status', 'created_at', 'updated_at']