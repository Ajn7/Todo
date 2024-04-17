from django.contrib.auth.models import User
from rest_framework import serializers

class RegistrationSerializer(serializers.ModelSerializer):
    password2=serializers.CharField(style={'input_type':'password'},write_only=True)
    
    class Meta:
        
        model=User
        fields = ['first_name', 'last_name', 'email', 'password','password2']
        
        extra_kwargs={
            'password':{'write_only':True}
        }
  
    def save(self):
        
        password=self.validated_data['password']
        password2=self.validated_data['password2']
        
        
        if User.objects.filter(email=self.validated_data['email']).exists():
            raise serializers.ValidationError({'error':'email already exists'})

    
        if password!= password2:
            raise serializers.ValidationError({'error':'Password1 and Password2 must be same'})
    
        account=User(email=self.validated_data['email'],username=self._validated_data['email'],first_name=self.validated_data['first_name'],last_name=self.validated_data['last_name'])
        account.set_password(password)
        account.save()
        return account