from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.authtoken.models import Token
from rest_framework import status
from rest_framework.views import APIView
from rest_framework import permissions
from django.contrib.auth import authenticate
from django.contrib.auth.models import User

from userapp import models #importing token signals

from django.contrib.auth import login
from userapp.api.serializers import RegistrationSerializer

@api_view(['post'])
def logout_view(request):
    
    if request.method == 'POST':
        request.user.auth_token.delete()
        return Response(status=status.HTTP_200_OK)
    
    
@api_view(['POST'])
def registration_view(request):
    
    if request.method == 'POST':
        serializer=RegistrationSerializer(data=request.data)
        data = {}
        
        if serializer.is_valid():
            
            account = serializer.save()
            data['response'] = "Registration successfull"
            data['email'] = account.email
            data['first_name'] = account.first_name
            data['last_name'] = account.last_name
            data['id']=account.id
            token = Token.objects.get(user=account).key
            data['token'] = token
            
        else:
            data=serializer.errors 
             
        return Response(data)  
    
@api_view(['POST'])
def loginaccount_view(request):
    if request.method == 'POST':
        email = request.data.get("email").lower()
        password = request.data.get("password")
        if email is None or password is None:
            return Response({'error': 'Please provide both email and password'},
                        status=status.HTTP_400_BAD_REQUEST)
        try:
            user=User.objects.get(email=email)
        except User.DoesNotExist:
            return Response({"response":"User does not exist on this email."},status=status.HTTP_400_BAD_REQUEST)
        if not user.check_password(password):
            return Response({"response":"Incorrect password"},status=status.HTTP_400_BAD_REQUEST)
        if not user:
            return Response({'error': 'Invalid credentials'},
                        status=status.HTTP_404_NOT_FOUND)
        name=User.objects.get(email=email).first_name+' '+User.objects.get(email=email).last_name
        id=User.objects.get(email=email).id
        token, _ = Token.objects.get_or_create(user=user)
        return Response({'token': token.key, 'email':email,'id':id,'name':name},
                    status=status.HTTP_200_OK)
    
@api_view(['POST'])
def deleteaccount_view(request):
    #permission_classes = [permissions.IsAuthenticated]
    if request.method == 'POST':
        email=request.POST["email"]
        password=request.POST["password"]
        #user =authenticate(username=username, password=password)
        try:
            user=User.objects.get(email=email)
        except User.DoesNotExist:
            return Response({"response":"User does not exist."})
        # if  user is None: not working 
        #     return Response({"response":"User does not exist."}) 
        if not user.check_password(password):
            return Response({"response":"Incorrect password"})
        
        user.delete()
        return Response({"result":"User deleted successfully"}) 
    
    
@api_view(['GET'])
def details_view(request):
    data={}
    if request.method == 'GET':    
        token=request.user.auth_token
        user_id = token.user_id
        user = User.objects.get(pk=user_id)
        data['email'] = user.email
        data['first_name'] = user.first_name
        data['last_name'] = user.last_name
        data['id']=user.pk
    return Response(data)
    
    