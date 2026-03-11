import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final String id;
  final String title;
  final String description;
  final String posterUrl;
  final String duration;
  final String genres;
  final String rating;
  final String releaseDate;
  final bool highlight;

  const Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
    required this.duration,
    required this.genres,
    required this.rating,
    required this.releaseDate,
    this.highlight = false,
  });

  @override
  List<Object?> get props => [
        id, title, description, posterUrl, duration, genres,
        rating, releaseDate, highlight,
      ];
}
