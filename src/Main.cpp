#include "Platform/Platform.hpp"
#include <cmath>
sf::Texture enemyTexture;

double enemySpeed = .00029;
int WINDOW_W, WINDOW_H;

double getRandom()
{

	double random = rand() % 10 * enemySpeed;

	if (random == 0)
		random = rand() % 10 * enemySpeed;

	random *= 10000;

	if (rand() % 10 > 5)
		random *= -1;

	return random;
}

void createEnemy(sf::Sprite* enemy)
{

	enemy->setPosition(getRandom() * 1000.f, getRandom() * 1000.f);
	enemy->scale(0.1f, 0.1f);
	enemy->setOrigin(sf::Vector2f(-.1, -.05));
	enemy->setTexture(enemyTexture);
}

sf::Sprite createNewEnemy()
{
	sf::Sprite enemy;
	enemy.setPosition(getRandom() * 1000.f, getRandom() * 1000.f);
	enemy.scale(0.1f, 0.1f);
	enemy.setOrigin(sf::Vector2f(-.1, -.05));
	enemy.setTexture(enemyTexture);
	return enemy;
}

void keepInBounds(sf::Sprite* entity)
{
	double xPosition = entity->getPosition().x;
	double yPosition = entity->getPosition().y;

	if (xPosition < 0)
	{
		entity->setPosition(0, yPosition);
		entity->move(getRandom() / 10, getRandom() / 10);
	}

	else if (yPosition < 0)
	{
		entity->setPosition(xPosition, 0);
		entity->move(getRandom() / 10, getRandom() / 10);
	}

	else if (xPosition > WINDOW_W)
	{
		entity->setPosition(WINDOW_W, yPosition);
		entity->move(getRandom() / 10, getRandom() / 10);
	}

	else if (yPosition > WINDOW_H)
	{
		entity->setPosition(xPosition, WINDOW_H);
		entity->move(getRandom() / 10, getRandom() / 10);
	}
}

void movePlayer(sf::Sprite* player, double playerSpeed)
{
	if (sf::Keyboard::isKeyPressed(sf::Keyboard::A))
		player->move(-playerSpeed, 0);
	if (sf::Keyboard::isKeyPressed(sf::Keyboard::D))
		player->move(playerSpeed, 0);
	if (sf::Keyboard::isKeyPressed(sf::Keyboard::W))
		player->move(0, -playerSpeed);
	if (sf::Keyboard::isKeyPressed(sf::Keyboard::S))
		player->move(0, playerSpeed);
	if (sf::Keyboard::isKeyPressed(sf::Keyboard::Right))
		player->rotate(playerSpeed);
	if (sf::Keyboard::isKeyPressed(sf::Keyboard::Left))
		player->rotate(-playerSpeed);
}

int main()
{

	util::Platform platform;
	sf::RenderWindow window;

	float screenScalingFactor = platform.getScreenScalingFactor(window.getSystemHandle());
	auto image = sf::Image {};

	image.loadFromFile("content/icon.png");

	window.create(sf::VideoMode(1000.0f * screenScalingFactor, 1000.0f * screenScalingFactor), "Gemini");
	window.setIcon(image.getSize().x, image.getSize().y, image.getPixelsPtr());
	WINDOW_H = window.getSize().y;
	WINDOW_W = window.getSize().x;

	enemyTexture.setSmooth(true);
	enemyTexture.loadFromFile("content/enemy.png");

	sf::Texture playerTexture;
	playerTexture.setSmooth(true);
	playerTexture.loadFromFile("content/player.png");

	sf::Sprite player;
	player.setOrigin((sf::Vector2f)playerTexture.getSize() / 2.f);
	player.setPosition(500.f, 500.f);
	player.scale(0.1f, 0.1f);
	player.setTexture(playerTexture);

	int numEnemies = 16;
	sf::Sprite enemies[16];
	for (int i = 0; i < numEnemies; i++)
		enemies[i] = createNewEnemy();

	sf::Event event;
	double playerSpeed = 0.2;

	for (int i = 0; i < numEnemies; i++)
		enemies[i].move(getRandom() * 1000, getRandom() * 1000);

	while (window.isOpen())
	{

		window.clear();

		while (window.pollEvent(event))
		{
			if (event.type == sf::Event::Closed)
				window.close();
		}

		sf::FloatRect playerBox = player.getGlobalBounds();
		for (int i = 0; i < numEnemies; i++)
		{
			sf::FloatRect enemyBox = enemies[i].getGlobalBounds();
			enemyBox.left /= 2;
			enemyBox.top /= 2;

			if (playerBox.intersects(enemyBox))
			{
				//numEnemies--;
			}
		}

		movePlayer(&player, playerSpeed);
		keepInBounds(&player);
		for (int i = 0; i < numEnemies; i++)
		{
			enemies[i].move(getRandom() / 40, getRandom() / 40);
			keepInBounds(&enemies[i]);
		}

		window.draw(player);
		for (int i = 0; i < numEnemies; i++)
		{
			window.draw(enemies[i]);
		}
		window.display();
	}

	return 0;
}