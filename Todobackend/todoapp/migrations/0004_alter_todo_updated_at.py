# Generated by Django 4.0.3 on 2024-04-18 20:15

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('todoapp', '0003_todo_title'),
    ]

    operations = [
        migrations.AlterField(
            model_name='todo',
            name='updated_at',
            field=models.DateTimeField(auto_now_add=True),
        ),
    ]
