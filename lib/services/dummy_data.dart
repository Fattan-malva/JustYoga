import '../models/gym_class.dart';
import '../models/trainer.dart';
import '../models/user.dart';
import '../models/booking.dart';

final demoUser = UserModel(
  id: 'u1',
  name: 'Fattan Malva',
  email: 'fattan@gmail.com',
  avatarUrl: 'https://i.pravatar.cc/150?img=12',
);

final demoTrainers = [
  Trainer(
    id: 't1',
    name: 'Ayu Santika',
    avatar: 'https://i.pravatar.cc/150?img=32',
    bio: 'Certified Yoga & Mindfulness instructor with 8 years experience.',
    specialties: ['Yoga', 'Mindfulness', 'Flexibility'],
  ),
  Trainer(
    id: 't2',
    name: 'Rifqi Pratama',
    avatar: 'https://i.pravatar.cc/150?img=47',
    bio: 'Strength & conditioning coach. Ex-athlete.',
    specialties: ['Strength', 'HIIT', 'Functional'],
  ),
];

final demoClasses = [
  GymClass(
    id: 'c1',
    title: 'Morning Yoga Flow',
    image: 'https://images.unsplash.com/photo-1558611848-73f7eb4001d4',
    description: 'Start your day with gentle movements and breathwork.',
    price: 30.0,
    rating: 4.8,
    trainerId: 't1',
  ),
  GymClass(
    id: 'c2',
    title: 'HIIT Burn',
    image: 'https://images.unsplash.com/photo-1517964103337-91ca229ff6a4',
    description: 'High-intensity interval training to improve VO2 max and burn calories.',
    price: 45.0,
    rating: 4.6,
    trainerId: 't2',
  ),
];

final demoBookings = [
  Booking(
    id: 'b1',
    classId: 'c1',
    userId: 'u1',
    date: DateTime.now().add(Duration(days: 1)),
    status: 'booked',
  ),
];
