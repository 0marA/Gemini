#include "Platform/Platform.hpp"

int main()
{
	util::Platform platform;
	sf::RenderWindow window;

	float screenScalingFactor = platform.getScreenScalingFactor(window.getSystemHandle());
	auto image = sf::Image {};

	image.loadFromFile("content/icon.png");

	window.create(sf::VideoMode(1000.0f * screenScalingFactor, 1000.0f * screenScalingFactor), "Gemini");
	window.setIcon(image.getSize().x, image.getSize().y, image.getPixelsPtr());

	sf::Texture playerTexture;
	playerTexture.setSmooth(true);
	playerTexture.loadFromFile("content/player.png");

	sf::Sprite player;
	player.setPosition(100.f, 0.f);
	player.scale(0.1f, 0.1f);
	player.setRotation(90.f);
	player.setTexture(playerTexture);

	//sf::FloatRect boundingBox = player.getGlobalBounds();
	//sf::Vector2f point = { 100.f, 100.f };

	sf::Event event;

	while (window.isOpen())
	{
		while (window.pollEvent(event))
		{
			if (event.type == sf::Event::Closed)
				window.close();
		}

		if (sf::Keyboard::isKeyPressed(sf::Keyboard::Left))
		{
			player.move(-.1, 0);
		}
		if (sf::Keyboard::isKeyPressed(sf::Keyboard::Right))
		{
			player.move(.1, 0);
		}
		if (sf::Keyboard::isKeyPressed(sf::Keyboard::Up))
		{
			player.move(0, -.1);
		}
		if (sf::Keyboard::isKeyPressed(sf::Keyboard::Down))
		{
			player.move(0, .1);
		}
		window.clear();
		window.draw(player);
		window.display();
	}

	return 0;
}
