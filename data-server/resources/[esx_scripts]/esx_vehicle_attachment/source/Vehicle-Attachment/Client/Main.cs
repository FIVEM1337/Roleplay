/*
 * Inferno Collection  1.5 Beta
 * 
 * Copyright (c) 2019-2021, Christopher M, Inferno Collection. All rights reserved.
 * 
 * This project is licensed under the following:
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to use, copy, modify, and merge the software, under the following conditions:
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 * The software may not be sold in any format.
 * Modified copies of the software may only be shared in an uncompiled format.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

using System;
using System.Linq;
using System.Threading.Tasks;
using System.Collections.Generic;
using Newtonsoft.Json;
using CitizenFX.Core;
using CitizenFX.Core.UI;
using CitizenFX.Core.Native;
using InfernoCollection.VehicleAttachment.Client.Models;

namespace InfernoCollection.VehicleCollection.Client
{
	public class Main : BaseScript
	{
		dynamic ESX;

		#region Configuration Variables
		internal readonly Vector3
			POSITION_VECTOR = new Vector3(0.0f, -2.0f, 1.5f),
			ROTATION_VECTOR = new Vector3(0.0f, 0.0f, 0.0f),
			RAYCAST_VECTOR = new Vector3(0.0f, 2.0f, 0.0f);

		internal const string
			CONFIG_FILE_NAME = "config.json",
			TOW_CONTROLS =
				"~INPUT_F8DD5118~/~INPUT_2F20FA6E~ = Vorwärts/Rückwärts" +
				"\n~INPUT_872241C1~/~INPUT_DEEBB52A~ = Links/Rechts" +
				"\n~INPUT_32D078AF~/~INPUT_7B7B256B~ = Hoch/Runter" +
				"\n~INPUT_6DC8415B~/~INPUT_4EEC321F~ = Nach Links/Rechts drehen" +
				"\n~INPUT_83B8F159~/~INPUT_EE722E7A~ = Rotate Up/Down" +
				"\nHold ~INPUT_SPRINT~/~INPUT_DUCK~ = Beschleunigen/Verlangsamen" +
				"\n~INPUT_94172EE1~ = Position bestätigen";
		#endregion

		#region General Variables
		internal bool
			_driveOn,
			_goFaster,
			_goSlower;

		internal Vehicle
			_tempTowVehicle,
			_tempVehicleBeingTowed;

		internal Config _config = new Config();

		internal AttachmentStage _attachmentStage;
		internal AttachmentStage _previousAttachmentStage;
		#endregion

		#region Constructor
		public Main()
		{
			TriggerEvent("esx:getSharedObject", new object[] { new Action<dynamic>(esx => {
				ESX = esx;
			})});
			Game.PlayerPed.State.Set("oneSyncTest", "test", true);
			if (Game.PlayerPed.State.Get("oneSyncTest") == null)
			{
				throw new Exception("This resource requires at least OneSync \"legacy\". Use Public Beta Version 1.3 if you do not want to use OneSync.");
			}

			TriggerEvent("chat:addSuggestion", "/attach [driveon|help|cancel]", "Starts the process of attaching one vehicle to another.");
			TriggerEvent("chat:addSuggestion", "/detach [help|cancel]", "Starts the process of detaching one vehicle from another.");

			#region Key Mapping
			API.RegisterKeyMapping("inferno-vehicle-attachment-forward", "Fahrzeug vorwärts bewegen.", "keyboard", "NUMPAD8"); // ~INPUT_F8DD5118~
			API.RegisterKeyMapping("inferno-vehicle-attachment-back", "Fahrzeug rückwärts bewegen.", "keyboard", "NUMPAD5"); // ~INPUT_2F20FA6E~
			API.RegisterKeyMapping("inferno-vehicle-attachment-left", "Fahrzeug nach links bewegen.", "keyboard", "NUMPAD4"); // ~INPUT_872241C1~
			API.RegisterKeyMapping("inferno-vehicle-attachment-right", "Fahrzeug nach rechts bewegen.", "keyboard", "NUMPAD6"); // ~INPUT_DEEBB52A~
			API.RegisterKeyMapping("inferno-vehicle-attachment-up", "Fahrzeug nach oben bewegen.", "keyboard", "ADD"); // ~INPUT_32D078AF~
			API.RegisterKeyMapping("inferno-vehicle-attachment-down", "Fahrzeug nach unten bewegen.", "keyboard", "SUBTRACT"); // ~INPUT_7B7B256B~
			API.RegisterKeyMapping("inferno-vehicle-attachment-rotate-left", "Fahrzeug nach links drehen.", "keyboard", "NUMPAD7"); // ~INPUT_6DC8415B~
			API.RegisterKeyMapping("inferno-vehicle-attachment-rotate-right", "Fahrzeug nach rechts drehen.", "keyboard", "NUMPAD9"); /// ~INPUT_4EEC321F~
			API.RegisterKeyMapping("inferno-vehicle-attachment-rotate-up", "Fahrzeug nach oben drehen.", "keyboard", "INSERT"); // ~INPUT_83B8F159~
			API.RegisterKeyMapping("inferno-vehicle-attachment-rotate-down", "Fahrzeug nach unten drehen.", "keyboard", "DELETE"); // ~INPUT_EE722E7A~
			API.RegisterKeyMapping("inferno-vehicle-attachment-confirm", "Fahrzeug abschleppen bestätigen.", "keyboard", "NUMPADENTER"); // ~INPUT_CAAAA4F4~
			#endregion

			#region Load configuration file
			string ConfigFile = null;

			try
			{
				ConfigFile = API.LoadResourceFile("inferno-vehicle-attachment", CONFIG_FILE_NAME);
			}
			catch (Exception exception)
			{
				Debug.WriteLine("Error loading configuration from file, could not load file contents. Reverting to default configuration values.");
				Debug.WriteLine(exception.ToString());
			}

			if (ConfigFile != null && ConfigFile != "")
			{
				try
				{
					_config = JsonConvert.DeserializeObject<Config>(ConfigFile);
				}
				catch (Exception exception)
				{
					Debug.WriteLine("Error loading configuration from file, contents are invalid. Reverting to default configuration values.");
					Debug.WriteLine(exception.ToString());
				}
			}
			else
			{
				Debug.WriteLine("Loaded configuration file is empty, reverting to defaults.");
			}
			#endregion
		}
		#endregion

		#region Command Handlers
		#region Attach/detach
		/// <summary>
		/// Triggers event that starts the attaching process.
		/// Also handles the triggering of the canceling process, and showing the help information.
		/// </summary>
		/// <param name="args">Command arguments</param>
		[Command("attach")]
		internal void OnAttach(string[] args)
		{

			var PlayerData = ESX.GetPlayerData();


			if (PlayerData.job.name == "mechanic")
			{
				if (args.Count() > 0)
				{
					if (args[0] == "help")
					{
						ShowTowControls();
					}
					else if (args[0] == "driveon")
					{
						_driveOn = !_driveOn;

						TriggerEvent("dopeNotify:Alert", "", $"Selbst fahren ist {(_driveOn ? "aktiv" : "nicht aktiv")}", 5000, "info");
					}
					else if (args[0] == "cancel")
					{
						if (_attachmentStage != AttachmentStage.None)
						{
							_previousAttachmentStage = _attachmentStage;
							_attachmentStage = AttachmentStage.Cancel;

							Game.PlaySound("CANCEL", "HUD_FREEMODE_SOUNDSET");
						}
						else
						{
							TriggerEvent("dopeNotify:Alert", "", "Du interagierst nicht mit einem Fahrzeug!", 5000, "error");
						}
					}
				}
				else
				{
					OnNewAttachment();
				}
			}
			else
			{
				TriggerEvent("dopeNotify:Alert", "", "Du bist nicht berechtigt das zu benutzen!", 5000, "error");
			}
		}

		/// <summary>
		/// Triggers event that starts the detaching process.
		/// Also handles the triggering of the canceling process, and showing the help information.
		/// </summary>
		/// <param name="args">Command arguments</param>
		[Command("detach")]
		internal void OnDetach(string[] args)
		{
			if (args.Count() > 0)
			{
				if (args[0] == "help")
				{
					ShowTowControls();
				}
				else if (args[0] == "cancel")
				{
					if (_attachmentStage != AttachmentStage.None)
					{
						_previousAttachmentStage = _attachmentStage;
						_attachmentStage = AttachmentStage.Cancel;

						Game.PlaySound("CANCEL", "HUD_FREEMODE_SOUNDSET");
					}
					else
					{
						TriggerEvent("dopeNotify:Alert", "", "Du interagierst nicht mit einem Fahrzeug!", 5000, "error");
					}
				}
			}
			else
			{
				OnRemoveLastAttachment();
			}
		}
		#endregion

		#region Controls
		[Command("inferno-vehicle-attachment-forward")]
		internal void OnForward() => OnControl(AttachmentControl.Forward);

		[Command("inferno-vehicle-attachment-back")]
		internal void OnBack() => OnControl(AttachmentControl.Back);

		[Command("inferno-vehicle-attachment-left")]
		internal void OnLeft() => OnControl(AttachmentControl.Left);

		[Command("inferno-vehicle-attachment-right")]
		internal void OnRight() => OnControl(AttachmentControl.Right);

		[Command("inferno-vehicle-attachment-up")]
		internal void OnUp() => OnControl(AttachmentControl.Up);

		[Command("inferno-vehicle-attachment-down")]
		internal void OnDown() => OnControl(AttachmentControl.Down);

		[Command("inferno-vehicle-attachment-rotate-left")]
		internal void OnRotateLeft() => OnControl(AttachmentControl.RotateLeft);

		[Command("inferno-vehicle-attachment-rotate-right")]
		internal void OnRotateRight() => OnControl(AttachmentControl.RotateRight);

		[Command("inferno-vehicle-attachment-rotate-up")]
		internal void OnRotateUp() => OnControl(AttachmentControl.RotateUp);

		[Command("inferno-vehicle-attachment-rotate-down")]
		internal void OnRotateDown() => OnControl(AttachmentControl.RotateDown);

		[Command("inferno-vehicle-attachment-confirm")]
		internal void OnConfirm() => OnControl(AttachmentControl.Confirm);
		#endregion
		#endregion

		#region Event Handlers
		/// <summary>
		/// Starts the process of attaching a <see cref="Vehicle"/> to another <see cref="Vehicle"/>
		/// </summary>
		[EventHandler("Inferno-Collection:Vehicle-Attachment:NewAttachment")]
		internal void OnNewAttachment()
		{
			if (_attachmentStage != AttachmentStage.None)
			{
				TriggerEvent("dopeNotify:Alert", "", "Du interagierst bereits mit einem anderen Fahrzeug!", 5000, "error");
			}
			else
			{
				_attachmentStage = AttachmentStage.TowTruck;
				Tick += AttachmentTick;

				Game.PlaySound("TOGGLE_ON", "HUD_FRONTEND_DEFAULT_SOUNDSET");
				TriggerEvent("dopeNotify:Alert", "", "Wähle ein Zugfahrzeug aus, um loszulegen!", 5000, "error");
			}
		}

		/// <summary>
		/// Starts the process of detaching one <see cref="Vehicle"/> from <see cref="Vehicle"/> vehicle
		/// </summary>
		[EventHandler("Inferno-Collection:Vehicle-Attachment:RemoveLastAttachment")]
		internal void OnRemoveLastAttachment()
		{
			if (Entity.Exists(_tempTowVehicle) || Entity.Exists(_tempVehicleBeingTowed))
			{
				TriggerEvent("dopeNotify:Alert", "", "Benutze \"/attach cancel\" um abschleppen abzubrechen", 5000, "error");
			}
			else
			{
				Vehicle towVehicle = World.GetAllVehicles()
					.Where(i => Entity.Exists(i) && i.Position.DistanceToSquared(Game.PlayerPed.Position) <= _config.MaxDistanceFromTowVehicle)
					.OrderBy(i => i.Position.DistanceToSquared(Game.PlayerPed.Position))
					.FirstOrDefault(i => GetTowedVehicles(i).Count() > 0);

				if (_attachmentStage != AttachmentStage.None)
				{
					TriggerEvent("dopeNotify:Alert", "", "Du interagierst bereits mit einem anderen Fahrzeug!", 5000, "error");
				}
				else if (!Entity.Exists(towVehicle))
				{
					TriggerEvent("dopeNotify:Alert", "", "Kein passendes Fahrzeug gefunden!", 5000, "error");
				}
				else
				{
					List<TowedVehicle> towedVehicles = GetTowedVehicles(towVehicle);

					TowedVehicle towedVehicle = towedVehicles.Last();

					Vehicle vehicleBeingTowed = (Vehicle)Entity.FromNetworkId(towedVehicle.NetworkId);

					if (!Entity.Exists(vehicleBeingTowed))
					{
						Game.PlaySound("CANCEL", "HUD_FREEMODE_SOUNDSET");
						TriggerEvent("dopeNotify:Alert", "", "Abschleppendes Fahrzeug wurde gelöscht!", 5000, "error");
					}
					else
					{
						_tempTowVehicle = towVehicle;
						_tempVehicleBeingTowed = vehicleBeingTowed;

						Game.PlaySound("TOGGLE_ON", "HUD_FRONTEND_DEFAULT_SOUNDSET");

						if (_driveOn)
						{
							TriggerEvent("dopeNotify:Alert", "", $"{_tempVehicleBeingTowed.LocalizedName ?? "Fahrzeug"} gelößt, fahr das Fahrzeug runter.", 5000, "info");

							ResetTowedVehicle(_tempVehicleBeingTowed);
							SetVehicleAsBeingUsed(_tempVehicleBeingTowed, false);
							RemoveTowedVehicle(_tempTowVehicle, _tempVehicleBeingTowed);

							_tempTowVehicle = null;
							_tempVehicleBeingTowed = null;

							Game.PlaySound("WAYPOINT_SET", "HUD_FRONTEND_DEFAULT_SOUNDSET");
						}
						else
						{
							ShowTowControls();

							_tempVehicleBeingTowed.Opacity = 225;

							_attachmentStage = AttachmentStage.Detach;
							Tick += AttachmentTick;

							TriggerEvent("dopeNotify:Alert", "", "Folge den Anweisungen.", 5000, "info");
						}                        
					}
				}
			}
		}
		#endregion

		#region Tick Handlers
		/// <summary>
		/// Handles vehicle selection, attaching, detaching, and canceling
		/// </summary>
		internal async Task AttachmentTick()
		{
			switch (_attachmentStage)
			{
				#region Selecting tow truck
				case AttachmentStage.TowTruck:
					{
						Vehicle towTruck = FindVehicle();

						if (towTruck == null)
						{
							Screen.DisplayHelpTextThisFrame("Kein Fahrzeug gefunden!");
						}
						else if (IsAlreadyBeingUsed(towTruck))
						{
							Screen.DisplayHelpTextThisFrame($"{towTruck.LocalizedName ?? "Abschleppfahrzeug"} wird bereits verwendet.");
						}
						else if (
							(!_config.BlacklistToWhitelist && _config.AttachmentBlacklist.Contains(towTruck.Model)) ||
							(_config.BlacklistToWhitelist && !_config.AttachmentBlacklist.Contains(towTruck.Model))
						)
						{
							Screen.DisplayHelpTextThisFrame($"The {towTruck.LocalizedName ?? "Abschleppfahrzeug"} nicht als Abschleppfahrzeug geeignet!");
						}
						else if (_config.MaxNumberOfAttachedVehicles > 0 && GetTowedVehicles(towTruck).Count() >= _config.MaxNumberOfAttachedVehicles)
						{
							Screen.DisplayHelpTextThisFrame($"{towTruck.LocalizedName ?? "Abschleppfahrzeug"} kann keine Fahrzeuge mehr abschleppen.");
						}
						else
						{
							if (_config.EnableLine)
							{
								World.DrawLine(Game.PlayerPed.Position, towTruck.Position, System.Drawing.Color.FromArgb(255, 0, 255, 0));
							}

							Screen.DisplayHelpTextThisFrame($"~INPUT_FRONTEND_ACCEPT~ um {towTruck.LocalizedName ?? "Abschleppfahrzeug"} als Abschleppfahrzeug zu verwenden.");

							if (Game.IsControlJustPressed(0, Control.FrontendAccept))
							{
								Game.PlaySound("OK", "HUD_FRONTEND_DEFAULT_SOUNDSET");

								TriggerEvent("dopeNotify:Alert", "", $"{towTruck.LocalizedName ?? "Abschleppfahrzeug"} als Abschleppfahrzeug bestätigt! Wählen Sie nun ein Fahrzeug aus das abgeschleppt werden muss.", 5000, "info");

								_tempTowVehicle = towTruck;
								_attachmentStage = AttachmentStage.VehicleToBeTowed;

								SetVehicleAsBeingUsed(towTruck, true);

								await Delay(1000);
							}
						}
					}
					break;
				#endregion

				#region Selecting vehicle to be towed
				case AttachmentStage.VehicleToBeTowed:
					{
						Vehicle vehicleToBeTowed = FindVehicle();

						if (vehicleToBeTowed == null)
						{
							Screen.DisplayHelpTextThisFrame("Kein abschleppbares Fahrzeug gefunden!");
						}
						else if (!Entity.Exists(_tempTowVehicle))
						{
							_attachmentStage = AttachmentStage.Cancel;

							Game.PlaySound("CANCEL", "HUD_FREEMODE_SOUNDSET");
							TriggerEvent("dopeNotify:Alert", "", "Kann nichts abschleppen da das Abschleppfahrzeug nicht vorhanden ist!", 5000, "error");
						}
						else if (IsAlreadyBeingUsed(vehicleToBeTowed))
						{
							Screen.DisplayHelpTextThisFrame($"{vehicleToBeTowed.LocalizedName ?? "Fahrzeug"} wird bereits inteagiert.");
						}
						else if (
							(!_config.BlacklistToWhitelist && _config.AttachmentBlacklist.Contains(vehicleToBeTowed.Model)) ||
							(_config.BlacklistToWhitelist && _config.WhitelistForTowedVehicles && !_config.AttachmentBlacklist.Contains(vehicleToBeTowed.Model))
						)
						{
							Screen.DisplayHelpTextThisFrame($"{vehicleToBeTowed.LocalizedName ?? "Fahrzeug"} kann nicht abgeschleppt werden!");
						}
						else if (vehicleToBeTowed.Occupants.Length > 0)
						{
							Screen.DisplayHelpTextThisFrame($"{vehicleToBeTowed.LocalizedName ?? "Fahrzeug"} ist besetzt!");
						}
						else if (Entity.Exists(_tempTowVehicle) && vehicleToBeTowed.Position.DistanceToSquared2D(_tempTowVehicle.Position) > _config.MaxDistanceFromTowVehicle)
						{
							Screen.DisplayHelpTextThisFrame($"{vehicleToBeTowed.LocalizedName ?? "Fahrzeug"} ist zu weit vom {_tempTowVehicle.LocalizedName ?? "Abschleppfahrzeug"} entfernt!");
						}
						else
						{
							if (_config.EnableLine)
							{
								World.DrawLine(Game.PlayerPed.Position, vehicleToBeTowed.Position, System.Drawing.Color.FromArgb(255, 0, 255, 0));
							}

							Screen.DisplayHelpTextThisFrame($"~INPUT_FRONTEND_ACCEPT~ um {vehicleToBeTowed.LocalizedName ?? "Fahrzeug"} abzuschleppen.");

							if (Game.IsControlJustPressed(0, Control.FrontendAccept))
							{
								SetVehicleAsBeingUsed(vehicleToBeTowed, true);

								int timeout = 4;
								API.NetworkRequestControlOfNetworkId(vehicleToBeTowed.NetworkId);
								while (!API.NetworkHasControlOfNetworkId(vehicleToBeTowed.NetworkId) && timeout > 0)
								{
									timeout--;

									API.NetworkRequestControlOfNetworkId(vehicleToBeTowed.NetworkId);
									await Delay(250);
								}

								if (!API.NetworkHasControlOfNetworkId(vehicleToBeTowed.NetworkId))
								{
									Game.PlaySound("CANCEL", "HUD_FREEMODE_SOUNDSET");
									TriggerEvent("dopeNotify:Alert", "", $"Kann nicht {vehicleToBeTowed.LocalizedName ?? "Fahrzeug"} abschleppen.", 5000, "error");

									Debug.WriteLine($"Abschleppen nicht möglich {vehicleToBeTowed.LocalizedName} ({vehicleToBeTowed.NetworkId}); Fahrzeugbesitz konnte nicht beantragt werden!");

									_attachmentStage = AttachmentStage.Cancel;
								}
								else
								{
									Game.PlaySound("OK", "HUD_FRONTEND_DEFAULT_SOUNDSET");

									if (_driveOn)
									{
										TriggerEvent("dopeNotify:Alert", "", $"{vehicleToBeTowed.LocalizedName ?? "Fahrzeug"} als abzuschleppendes Fahrzeug bestätigt!", 5000, "success");

										vehicleToBeTowed.IsPersistent = true;

										AddNewTowedVehicle(_tempTowVehicle, new TowedVehicle() { NetworkId = vehicleToBeTowed.NetworkId });

										_tempVehicleBeingTowed = vehicleToBeTowed;
										_attachmentStage = AttachmentStage.DriveOn;

										await Delay(1000);
									}
									else
									{
										TriggerEvent("dopeNotify:Alert", "", $"{vehicleToBeTowed.LocalizedName ?? "Fahrzeug"} als abzuschleppendes Fahrzeug bestätigt!", 5000, "success");

										ShowTowControls();

										vehicleToBeTowed.Opacity = 225;
										vehicleToBeTowed.IsPersistent = true;
										vehicleToBeTowed.IsPositionFrozen = true;
										vehicleToBeTowed.IsCollisionEnabled = false;
										vehicleToBeTowed.LockStatus = VehicleLockStatus.CannotBeTriedToEnter;
										vehicleToBeTowed.AttachTo(_tempTowVehicle, POSITION_VECTOR, ROTATION_VECTOR);

										AddNewTowedVehicle(_tempTowVehicle, new TowedVehicle()
										{
											NetworkId = vehicleToBeTowed.NetworkId,
											AttachmentPosition = POSITION_VECTOR,
											AttachmentRotation = ROTATION_VECTOR
										});

										_tempVehicleBeingTowed = vehicleToBeTowed;
										_attachmentStage = AttachmentStage.Position;

										await Delay(1000);
									}
								}
							}
						}
					}
					break;
				#endregion

				#region Cancel current attachment
				case AttachmentStage.Cancel:
					{
						if (Entity.Exists(_tempTowVehicle))
						{
							if (!Entity.Exists(_tempVehicleBeingTowed))
							{
								SetVehicleAsBeingUsed(_tempTowVehicle, false);

								TriggerEvent("dopeNotify:Alert", "", "Abschleppen abgebrochen", 5000, "error");

								Tick -= AttachmentTick;
								_attachmentStage = AttachmentStage.None;
							}
							else
							{
								if (_tempTowVehicle.Position.DistanceToSquared2D(Game.PlayerPed.Position) > _config.MaxDistanceFromTowVehicle)
								{

									TriggerEvent("dopeNotify:Alert", "", $"{_tempTowVehicle.LocalizedName ?? "Abschleppfahrzeug"} zu weit weg!", 5000, "error");
								}
								else
								{
									ResetTowedVehicle(_tempVehicleBeingTowed);
									SetVehicleAsBeingUsed(_tempTowVehicle, false);
									SetVehicleAsBeingUsed(_tempVehicleBeingTowed, false);
									RemoveTowedVehicle(_tempTowVehicle, _tempVehicleBeingTowed);

									TriggerEvent("dopeNotify:Alert", "", "Abschleppen abgebrochen", 5000, "error");
									Tick -= AttachmentTick;
									_attachmentStage = AttachmentStage.None;
								}
							}
						}
						else
						{
							TriggerEvent("dopeNotify:Alert", "", "Abschleppen abgebrochen", 5000, "error");
							Tick -= AttachmentTick;
							_attachmentStage = AttachmentStage.None;
						}
					}
					break;
				#endregion

				#region Drive On
				case AttachmentStage.DriveOn:
					Screen.DisplayHelpTextThisFrame("Drücke ~INPUT_FRONTEND_RDOWN~ um die Position zu bestätigen");
					break;
				#endregion

				#region Position/Detach
				default:
					if (Game.IsControlPressed(0, Control.Sprint))
					{
						_goFaster = true;
						_goSlower = false;
						break;
					}
					else if (Game.IsControlPressed(0, Control.Duck))
					{
						_goFaster = false;
						_goSlower = true;
						break;
					}

					_goFaster = false;
					_goSlower = false;
					break;
				#endregion
			}
		}
		#endregion

		#region Functions
		/// <summary>
		/// Returns the <see cref="Vehicle"/> in front of the player
		/// </summary>
		/// <returns><see cref="Vehicle"/> in front of player</returns>
		internal Vehicle FindVehicle()
		{
			RaycastResult raycast = World.RaycastCapsule(Game.PlayerPed.Position, Game.PlayerPed.GetOffsetPosition(RAYCAST_VECTOR), 0.3f, (IntersectOptions)10, Game.PlayerPed);

			if (!raycast.DitHitEntity || !Entity.Exists(raycast.HitEntity) || !raycast.HitEntity.Model.IsVehicle)
			{
				return null;
			}

			return (Vehicle)raycast.HitEntity;
		}

		/// <summary>
		/// Properly detaches and resets a <see cref="Vehicle"/> that is attached to another <see cref="Vehicle"/>
		/// </summary>
		/// <param name="entity">Vehicle to reset in entity form</param>
		internal async void ResetTowedVehicle(Entity entity)
		{
			Vector3 position;
			Vehicle vehicle = (Vehicle)entity;

			vehicle.Opacity = 0;
			vehicle.Detach();

			if (!_driveOn)
			{
				position = vehicle.Position;

				vehicle.PlaceOnGround();
				vehicle.IsCollisionEnabled = true;
				vehicle.IsPositionFrozen = false;

				await Delay(1000);

				vehicle.Position = position;
			}

			vehicle.ResetOpacity();
			vehicle.LockStatus = VehicleLockStatus.Unlocked;
			vehicle.ApplyForce(new Vector3(0.0f, 0.0f, 0.001f));
		}

		/// <summary>
		/// Prints the tow controls to the chat box
		/// </summary>
		internal void ShowTowControls()
		{
			if (_config.EnableInstructions)
			{
				API.BeginTextCommandDisplayHelp("CELL_EMAIL_BCON");

				foreach (string s in Screen.StringToArray(TOW_CONTROLS))
				{
					API.AddTextComponentSubstringPlayerName(s);
				}

				API.EndTextCommandDisplayHelp(0, false, true, _config.InstructionDisplayTime);
			}
		}

		/// <summary>
		/// Handles the control input from the keybind maps
		/// </summary>
		/// <param name="attachmentControl"></param>
		internal void OnControl(AttachmentControl attachmentControl)
		{
			if (_attachmentStage != AttachmentStage.Position && _attachmentStage != AttachmentStage.Detach)
			{
				if (_attachmentStage != AttachmentStage.DriveOn || attachmentControl != AttachmentControl.Confirm)
				{
					return;
				}

				TowedVehicle towedVehicle = GetTowedVehicles(_tempTowVehicle).Last();

				if (_tempTowVehicle.Position.DistanceToSquared(_tempVehicleBeingTowed.Position) > _config.MaxDistanceFromTowVehicle)
				{
					TriggerEvent("dopeNotify:Alert", "", "Kann dort nicht befestigt werden, zu weit vom Zugfahrzeug entfernt!", 5000, "error");
					return;
				}

				if (Game.PlayerPed.CurrentVehicle == _tempVehicleBeingTowed)
				{
					Game.PlayerPed.Task.LeaveVehicle();
				}

				Vector3
					position = _tempTowVehicle.GetPositionOffset(_tempVehicleBeingTowed.Position),
					rotation = _tempVehicleBeingTowed.Rotation - _tempTowVehicle.Rotation;

				_tempVehicleBeingTowed.LockStatus = VehicleLockStatus.CannotBeTriedToEnter;
				_tempVehicleBeingTowed.AttachTo(_tempTowVehicle, position, rotation);

				TowedVehicle updatedTowedVehicle = new TowedVehicle()
				{
					NetworkId = towedVehicle.NetworkId,
					AttachmentPosition = position,
					AttachmentRotation = rotation
				};

				UpdateTowedVehicle(_tempTowVehicle, _tempVehicleBeingTowed, updatedTowedVehicle);

				SetVehicleAsBeingUsed(_tempTowVehicle, false);
				SetVehicleAsBeingUsed(_tempVehicleBeingTowed, false);

				TriggerEvent("dopeNotify:Alert", "", "Fahrzeug abgeschleppen erfolgreich.", 5000, "success");

				_tempTowVehicle = null;
				_tempVehicleBeingTowed = null;

				Game.PlaySound("WAYPOINT_SET", "HUD_FRONTEND_DEFAULT_SOUNDSET");

				Tick -= AttachmentTick;
				_attachmentStage = AttachmentStage.None;
				return;
			}

			float changeAmount = _config.ChangeAmount;

			changeAmount += _goFaster ? _config.FasterAmount : _goSlower ? _config.SlowerAmount : 0f;

			if (!Entity.Exists(_tempTowVehicle) || !Entity.Exists(_tempVehicleBeingTowed))
			{
				Game.PlaySound("CANCEL", "HUD_FREEMODE_SOUNDSET");
				TriggerEvent("dopeNotify:Alert", "", "Abschleppen abgebrochen.", 5000, "error");

				_attachmentStage = AttachmentStage.Cancel;
			}
			else
			{
				TowedVehicle towedVehicle = GetTowedVehicles(_tempTowVehicle).Last();

				Vector3
					position = towedVehicle.AttachmentPosition,
					rotation = towedVehicle.AttachmentRotation;

				switch (attachmentControl)
				{
					case AttachmentControl.Forward:
						position.Y += changeAmount;
						break;

					case AttachmentControl.Back:
						position.Y -= changeAmount;
						break;

					case AttachmentControl.Left:
						position.X -= changeAmount;
						break;

					case AttachmentControl.Right:
						position.X += changeAmount;
						break;

					case AttachmentControl.Up:
						position.Z += changeAmount;
						break;

					case AttachmentControl.Down:
						position.Z -= changeAmount;
						break;

					case AttachmentControl.RotateLeft:
						rotation.Z += changeAmount * 10;
						break;

					case AttachmentControl.RotateRight:
						rotation.Z -= changeAmount * 10;
						break;

					case AttachmentControl.RotateUp:
						rotation.X += changeAmount * 10;
						break;

					case AttachmentControl.RotateDown:
						rotation.X -= changeAmount * 10;
						break;

					case AttachmentControl.Confirm:
						SetVehicleAsBeingUsed(_tempTowVehicle, false);
						SetVehicleAsBeingUsed(_tempVehicleBeingTowed, false);

						if (_attachmentStage == AttachmentStage.Position)
						{
							TriggerEvent("dopeNotify:Alert", "", "Fahrzeug abgeschleppen erfolgreich.", 5000, "success");

							_tempVehicleBeingTowed.ResetOpacity();
							_tempVehicleBeingTowed.IsCollisionEnabled = true;
						}
						else if (_attachmentStage == AttachmentStage.Detach)
						{
							TriggerEvent("dopeNotify:Alert", "", $"{_tempVehicleBeingTowed.LocalizedName ?? "Fahrzeug"} detached!", 5000, "success");

							ResetTowedVehicle(_tempVehicleBeingTowed);
							SetVehicleAsBeingUsed(_tempVehicleBeingTowed, false);
							RemoveTowedVehicle(_tempTowVehicle, _tempVehicleBeingTowed);
						}

						_tempTowVehicle = null;
						_tempVehicleBeingTowed = null;

						Game.PlaySound("WAYPOINT_SET", "HUD_FRONTEND_DEFAULT_SOUNDSET");

						Tick -= AttachmentTick;
						_attachmentStage = AttachmentStage.None;
						return;
				}

				if (_tempTowVehicle.Position.DistanceToSquared(_tempTowVehicle.GetOffsetPosition(position)) > _config.MaxDistanceFromTowVehicle)
				{
					TriggerEvent("dopeNotify:Alert", "", "Kann nicht dort Positioniert werden zu weit von der Zugmaschine entfernt", 5000, "error");
				}
				else
				{
					_tempVehicleBeingTowed.AttachTo(_tempTowVehicle, position, rotation);

					TowedVehicle updatedTowedVehicle = new TowedVehicle()
					{
						NetworkId = towedVehicle.NetworkId,
						AttachmentPosition = position,
						AttachmentRotation = rotation
					};

					UpdateTowedVehicle(_tempTowVehicle, _tempVehicleBeingTowed, updatedTowedVehicle);
				}
			}
		}

		/// <summary>
		/// Determines if a <see cref="Vehicle"/> is already being used as a
		/// tow truck (mid placement), or a vehicle being towed
		/// </summary>
		/// <param name="Fahrzeug"><see cref="Vehicle"/> to check</param>
		/// <returns></returns>
		internal bool IsAlreadyBeingUsed(Vehicle vehicle)
		{
			if (vehicle.State.Get("isBeingUsed") == null)
			{
				vehicle.State.Set("isBeingUsed", false, true);
			}

			return vehicle.State.Get("isBeingUsed");
		}

		/// <summary>
		/// Sets a <see cref="Vehicle"/> as in use
		/// </summary>
		/// <param name="Fahrzeug"><see cref="Vehicle"/> to set</param>
		/// <param name="beingUsed"><see cref="bool"/> to set</param>
		internal void SetVehicleAsBeingUsed(Vehicle vehicle, bool beingUsed)
		{
			// Initializes if null
			bool _ = IsAlreadyBeingUsed(vehicle);

			vehicle.State.Set("isBeingUsed", beingUsed, true);
		}

		/// <summary>
		/// Returns a <see cref="List{TowedVehicle}"/> a <see cref="Vehicle"/> is towing
		/// </summary>
		/// <param name="Fahrzeug"><see cref="Vehicle"/> to check</param>
		/// <returns></returns>
		internal List<TowedVehicle> GetTowedVehicles(Vehicle vehicle)
		{
			if (vehicle.State.Get("vehiclesBeingTowed") == null)
			{
				vehicle.State.Set("vehiclesBeingTowed", JsonConvert.SerializeObject(new List<TowedVehicle>()), true);
			}

			return JsonConvert.DeserializeObject<List<TowedVehicle>>(vehicle.State.Get("vehiclesBeingTowed"));
		}

		/// <summary>
		/// Adds a new <see cref="TowedVehicle"/> as a vehicle being towed
		/// </summary>
		/// <param name="towVehicle"><see cref="Vehicle"/> doing the towing</param>
		/// <param name="towedVehicle"><see cref="TowedVehicle"/> being towed</param>
		internal void AddNewTowedVehicle(Vehicle towVehicle, TowedVehicle towedVehicle)
		{
			List<TowedVehicle> towedVehicles = GetTowedVehicles(towVehicle);

			towedVehicles.Add(towedVehicle);

			towVehicle.State.Set("vehiclesBeingTowed", JsonConvert.SerializeObject(towedVehicles), true);
		}

		/// <summary>
		/// Updates a <see cref="TowedVehicle"/> that is already being towed
		/// </summary>
		/// <param name="towVehicle"><see cref="Vehicle"/> doing the towing</param>
		/// <param name="towedVehicle"><see cref="Vehicle"/> being towed</param>
		/// <param name="updatedTowedVehicle">Updated <see cref="TowedVehicle"/> information</param>
		internal void UpdateTowedVehicle(Vehicle towVehicle, Vehicle towedVehicle, TowedVehicle updatedTowedVehicle)
		{
			List<TowedVehicle> towedVehicles = GetTowedVehicles(towVehicle);

			towedVehicles.RemoveAll(i => i.NetworkId == towedVehicle.NetworkId);
			towedVehicles.Add(updatedTowedVehicle);

			towVehicle.State.Set("vehiclesBeingTowed", JsonConvert.SerializeObject(towedVehicles), true);
		}

		/// <summary>
		/// Removes a <see cref="Vehicle"/> as being towed
		/// </summary>
		/// <param name="towVehicle"><see cref="Vehicle"/> doing the towing</param>
		/// <param name="towedVehicle"><see cref="Vehicle"/> being towed</param>
		internal void RemoveTowedVehicle(Vehicle towVehicle, Vehicle towedVehicle)
		{
			List<TowedVehicle> towedVehicles = GetTowedVehicles(towVehicle);

			towedVehicles.RemoveAll(i => i.NetworkId == towedVehicle.NetworkId);

			towVehicle.State.Set("vehiclesBeingTowed", JsonConvert.SerializeObject(towedVehicles), true);
		}
		#endregion
	}
}
